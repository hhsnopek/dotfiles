local M = {}

local border = 'rounded'

function M.setup()
  -- Mason installs LSP binaries to ~/.local/share/nvim/mason/bin and prepends
  -- that dir to $PATH. Must run BEFORE vim.lsp.enable() so the resolver
  -- finds the binaries.
  require('mason').setup({
    ui = {
      border = border,
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
    },
  })

  require('mason-lspconfig').setup({
    ensure_installed = {
      'gopls',
      'lua_ls',
      'bashls',
      'dockerls',
      'sqlls',
      'terraformls',
      'vimls',
    },
    -- mason-lspconfig 2.x calls vim.lsp.enable() for any installed server.
    -- We still call vim.lsp.enable() explicitly below for clarity, which is harmless.
    automatic_enable = true,
  })

  -- Server-specific overrides. nvim-lspconfig ships default cmd/root_dir/
  -- filetypes for every server under its `config/` directory; those are
  -- picked up automatically via Neovim's vim.lsp.config registry. We only
  -- need to add settings / merge here.

  vim.lsp.config('gopls', {
    settings = {
      gopls = {
        gofumpt = true,
        analyses = {
          unusedparams = true,
          shadow = true,
          nilness = true,
          unusedwrite = true,
        },
        staticcheck = true,
        usePlaceholders = true,
        completeUnimported = true,
        experimentalPostfixCompletions = true,
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  })

  -- Point golangci-lint-langserver at a project-built binary when one exists.
  -- clerk_go ships `local/bin/custom-gcl` (a vendored golangci-lint with org
  -- linter plugins) — mason's generic binary doesn't have those plugins,
  -- so diagnostics would diverge from CI without this. We only swap the
  -- binary; nvim-lspconfig already supplies the right flags via init_options.
  vim.lsp.config('golangci_lint_ls', {
    before_init = function(_, config)
      local root = config.root_dir or vim.fn.getcwd()
      for _, rel in ipairs({ 'local/bin/custom-gcl', 'local/bin/golangci-lint', 'bin/golangci-lint' }) do
        local path = root .. '/' .. rel
        if vim.uv.fs_stat(path) then
          config.init_options = config.init_options or {}
          config.init_options.command = vim.deepcopy(config.init_options.command or { 'golangci-lint', 'run' })
          config.init_options.command[1] = path
          return
        end
      end
    end,
  })

  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  })

  -- Enable servers. Anything missing on $PATH will simply not attach;
  -- check :checkhealth vim.lsp to see status.
  vim.lsp.enable({
    'gopls',
    'lua_ls',
    'bashls',
    'dockerls',
    'sqlls',
    'terraformls',
    'vimls',
  })

  -- Diagnostics
  vim.diagnostic.config({
    virtual_text = { prefix = '●', source = 'if_many' },
    float = { border = border, source = true },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = ' ',
        [vim.diagnostic.severity.WARN]  = ' ',
        [vim.diagnostic.severity.HINT]  = ' ',
        [vim.diagnostic.severity.INFO]  = ' ',
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  -- Hover/signature windows get a border
  vim.lsp.buf.hover = (function(orig)
    return function(opts)
      opts = opts or {}
      opts.border = opts.border or border
      return orig(opts)
    end
  end)(vim.lsp.buf.hover)

  vim.lsp.buf.signature_help = (function(orig)
    return function(opts)
      opts = opts or {}
      opts.border = opts.border or border
      return orig(opts)
    end
  end)(vim.lsp.buf.signature_help)

  -- Buffer-local LSP keymaps + native completion on attach
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then return end

      local buf = ev.buf
      local opts = { buffer = buf, silent = true }

      -- Only bind a key if the client advertises the capability — otherwise
      -- the keystroke falls through to Vim's default (e.g. gD → keyword search).
      local function map_if(method, mode, lhs, rhs)
        if client:supports_method(method) then
          vim.keymap.set(mode, lhs, rhs, opts)
        end
      end

      -- Navigation
      map_if('textDocument/declaration',    'n', 'gD',    vim.lsp.buf.declaration)
      map_if('textDocument/definition',     'n', 'gd',    vim.lsp.buf.definition)
      map_if('textDocument/implementation', 'n', 'gi',    vim.lsp.buf.implementation)
      map_if('textDocument/references',     'n', 'gr',    vim.lsp.buf.references)
      map_if('textDocument/hover',          'n', 'K',     vim.lsp.buf.hover)
      map_if('textDocument/signatureHelp',  'n', '<C-k>', vim.lsp.buf.signature_help)

      -- Refactor / type
      map_if('textDocument/typeDefinition', 'n', '<space>D',  vim.lsp.buf.type_definition)
      map_if('textDocument/rename',         'n', '<space>rn', vim.lsp.buf.rename)
      map_if('textDocument/codeAction',     { 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action)
      map_if('textDocument/formatting',     'n', '<space>f', function()
        vim.lsp.buf.format({ async = true })
      end)

      -- Workspace
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)

      -- Native LSP-driven completion (Neovim 0.11+). No nvim-cmp needed.
      if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
        vim.bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
      end

      -- Inlay hints (Neovim 0.10+). Off by default — toggle with <leader>ih.

      -- Format on save
      if client:supports_method('textDocument/formatting') then
        local fmt_group = vim.api.nvim_create_augroup('user-lsp-format-' .. buf, { clear = true })
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = fmt_group,
          buffer = buf,
          callback = function()
            vim.lsp.buf.format({ bufnr = buf, id = client.id, async = false })
          end,
        })
      end
    end,
  })

  -- Diagnostic-level keymaps (global; not buffer-local)
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
  vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end)
  vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
end

return M
