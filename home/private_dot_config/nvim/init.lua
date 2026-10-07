-- Environment detection
local env = require('config.env')

-- Core options (must run before plugins; sets leader, etc.)
require('config.options')

-- Standalone-only initialization
if env.is_standalone() then
  -- Prevent nested Neovim from a :terminal
  vim.env.IN_NEOVIM = 'true'
  vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
  vim.env.NVIM_LISTEN_ADDRESS = vim.v.servername

  -- Plugins (vim.pack — Neovim 0.12+ built-in package manager)
  require('config.plugins')

  -- LSP (native vim.lsp.config + vim.lsp.enable, no mason)
  require('config.lsp').setup()

  -- Registered before :colorscheme so they also apply at startup.
  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function()
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#000000' })
      vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#ffffff', bg = '#333333' })
    end,
  })

  -- distilled clears syntax groups but leaves Neovim's default colors on
  -- groups it predates, so pull those back onto its palette.
  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = 'distilled',
    callback = function()
      for _, group in ipairs({ '@variable', '@variable.parameter', '@variable.member', 'Operator' }) do
        vim.api.nvim_set_hl(0, group, {})
      end
      local palette = {
        Added = '#88c563',
        Removed = '#e76d6d',
        Changed = '#ecb534',
        DiagnosticError = '#e76d6d',
        DiagnosticWarn = '#ecb534',
        DiagnosticInfo = '#65baf5',
        DiagnosticHint = '#9fcce7',
        DiagnosticOk = '#88c563',
      }
      for group, color in pairs(palette) do
        vim.api.nvim_set_hl(0, group, { fg = color })
      end
      for _, level in ipairs({ 'Error', 'Warn', 'Info', 'Hint', 'Ok' }) do
        vim.api.nvim_set_hl(0, 'DiagnosticUnderline' .. level, { undercurl = true, sp = palette['Diagnostic' .. level] })
      end
    end,
  })

  vim.cmd.colorscheme('distilled')
end

require('config.keymaps')
require('config.autocmds')
