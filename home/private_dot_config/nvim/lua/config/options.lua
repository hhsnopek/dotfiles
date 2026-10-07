-- Basic Neovim options
local opt = vim.opt
local g = vim.g
local env = require('config.env')

-- Leader first — any keymap defined later observes this
g.mapleader = ' '
g.maplocalleader = ' '

opt.compatible = false

-- Editor
opt.number = true
opt.relativenumber = true
opt.textwidth = 80
opt.wrap = true
opt.smartindent = false
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.clipboard = 'unnamed'
opt.signcolumn = 'yes'
opt.backspace = 'indent,eol,start'

-- Standalone-only visuals
if env.is_standalone() then
  opt.listchars = {
    tab = '\\t',
    extends = '›',
    precedes = '‹',
    nbsp = '•',
    trail = '•',
  }
  opt.ruler = true
  opt.termguicolors = true
  opt.background = 'dark'
  opt.inccommand = 'split'
end

-- Search
opt.ignorecase = true
opt.smartcase = true

-- File handling
opt.autowrite = env.is_standalone()
opt.undofile = true

-- Folding via treesitter (start unfolded; toggle with za / zR / zM)
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldenable = false
opt.foldlevel = 99

-- Status line
opt.statusline = '[%M%n] %y %t %= %l:%c'

-- Filetype detection (no smart indent — we use treesitter / manual indent)
vim.cmd('filetype plugin on')
vim.cmd('filetype indent off')

-- netrw
g.netrw_banner = 0
g.netrw_list_hide = table.concat({
  '\\(^\\|\\s\\s\\)\\zs\\.\\S\\+',
  '\\.git$',
  '\\.DS_Store$',
  'node_modules',
  '\\.o$',
  '\\.tmp$',
  '\\.swp$',
  '\\.swo$',
}, ',')
g.netrw_fastbrowse = env.is_vscode() and 0 or 2
