-- Plugin management via vim.pack (Neovim 0.12+ built-in)
--
-- vim.pack.add installs missing plugins synchronously on first run and
-- prepends them to runtimepath. Use :checkhealth vim.pack to inspect state,
-- :PackUpdate (custom command below) to update, and vim.pack.del() to remove.

local env = require('config.env')

if env.is_vscode() then
  return
end

vim.pack.add({
  -- netrw enhancement
  { src = 'https://github.com/tpope/vim-vinegar' },

  -- Git
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/airblade/vim-gitgutter' },
  { src = 'https://github.com/almo7aya/openingh.nvim' },

  -- Colorscheme
  { src = 'https://github.com/KKPMW/distilled-vim' },

  -- Distraction-free / drawing
  { src = 'https://github.com/junegunn/goyo.vim' },

  -- Editing
  { src = 'https://github.com/tpope/vim-surround' },
  { src = 'https://github.com/junegunn/vim-easy-align' },

  -- LSP server installation + config
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },

  -- Go
  { src = 'https://github.com/ray-x/guihua.lua' },
  { src = 'https://github.com/ray-x/go.nvim' },

  -- Treesitter. Pinned to `master` because `main` (the rewrite) requires
  -- the `tree-sitter` CLI to compile parsers on first install. Master is
  -- archived but the prebuilt parser story still works; we patch its
  -- broken directives below for Neovim 0.11+ multi-capture queries.
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'master' },

  -- Telescope
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },
})

-- Build hooks for native extensions / parsers
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local data = ev.data
    if not data or data.kind == 'delete' then
      return
    end
    local name = data.spec and data.spec.name
    if name == 'telescope-fzf-native.nvim' then
      vim.notify('Building telescope-fzf-native', vim.log.levels.INFO)
      vim.system({ 'make' }, { cwd = data.path }):wait()
    elseif name == 'nvim-treesitter' then
      pcall(vim.cmd, 'TSUpdate')
    end
  end,
})

-- Treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'go', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline',
    'dockerfile', 'editorconfig', 'gitignore', 'git_config', 'git_rebase',
    'gomod', 'gosum', 'gowork', 'gotmpl', 'json', 'regex', 'sql',
    'typescript', 'yaml', 'toml',
  },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})

-- Patch master-branch directives for Neovim 0.11+. The shipped handlers
-- assume `match[capture_id]` is a single TSNode; in 0.11+ it's a list of
-- nodes and the call to :range() crashes. Force-load query_predicates so
-- our overrides win the last-write-wins race.
require('nvim-treesitter.query_predicates')
do
  local q = vim.treesitter.query
  local function pick_node(match, id)
    local v = match[id]
    if type(v) == 'table' then return v[#v] end
    return v
  end

  q.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
    local node = pick_node(match, pred[2])
    if not node then return end
    metadata['injection.language'] = vim.treesitter.get_node_text(node, bufnr):lower()
  end, { force = true, all = true })

  q.add_directive('downcase!', function(match, _, bufnr, pred, metadata)
    local node = pick_node(match, pred[2])
    if not node then return end
    local key = pred[3] or 'injection.language'
    metadata[key] = vim.treesitter.get_node_text(node, bufnr):lower()
  end, { force = true, all = true })

  -- Same defensive patch for any other directives that iterate match nodes
  q.add_directive('inject-bash-ps1!', function() end, { force = true, all = true })
end

-- Native commenting (`gc` / `gcc`) is built into Neovim 0.10+ and respects
-- treesitter `commentstring` automatically — no plugins needed.

-- Telescope
local telescope = require('telescope')
telescope.setup({})
pcall(telescope.load_extension, 'fzf')

-- Go
require('go').setup({
  lsp_gofumpt = true,
  lsp_cfg = false,
  lsp_inlay_hints = { enable = false }, -- toggled by <leader>ih in keymaps.lua
})
