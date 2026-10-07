-- Environment detection
local env = require('config.env')

-- Key mapping helper function
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Toggle wrap function
local function toggle_wrap()
    vim.opt.wrap = not vim.opt.wrap:get()
end

-- Navigation mappings (common to both environments)
map('n', '<leader>j', '<C-w>j')
map('n', '<leader>k', '<C-w>k')
map('n', '<leader>l', '<C-w>l')
map('n', '<leader>h', '<C-w>h')

-- Tab navigation
map('n', '<Tab>l', ':tabnext<cr>')
map('n', '<Tab>h', ':tabprevious<cr>')

-- Standalone-specific mappings
if env.is_standalone() then
  -- Telescope mappings
  map('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
  map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
  map('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
  map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')

  -- Terminal mappings
  map('t', ',j', '<C-\\><C-n><C-w>j')
  map('t', ',k', '<C-\\><C-n><C-w>k')
  map('t', ',l', '<C-\\><C-n><C-w>l')
  map('t', ',h', '<C-\\><C-n><C-w>h')
  map('t', '<esc>', '<C-\\><C-n>')
  map('t', '<C-\\>', '<esc>')
  map('t', ',tq', '<C-\\>:tabclose<cr>')
end

-- Disable arrow keys
for _, key in ipairs({ '<up>', '<down>', '<left>', '<right>' }) do
    map('i', key, '<nop>')
    map('n', key, '<nop>')
end
map('i', '<del>', '<nop>')

-- Common operations
map('n', '<leader>w', toggle_wrap) -- Toggle wrap mapping (common)
map('n', '<leader>?', function() require('config.cheatsheet').toggle() end, { desc = 'Toggle keymap cheatsheet' })

-- Inlay hint toggle (Neovim 0.10+)
map('n', '<leader>ih', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

-- Snippet placeholder navigation (Neovim 0.11+ vim.snippet).
-- Tab/S-Tab jump through snippet stops when one is active; otherwise pass through.
vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if vim.snippet.active({ direction = 1 }) then
    return '<cmd>lua vim.snippet.jump(1)<cr>'
  end
  return '<Tab>'
end, { expr = true, silent = true, desc = 'Snippet: jump next / Tab' })

vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  if vim.snippet.active({ direction = -1 }) then
    return '<cmd>lua vim.snippet.jump(-1)<cr>'
  end
  return '<S-Tab>'
end, { expr = true, silent = true, desc = 'Snippet: jump prev / S-Tab' })

-- Standalone-specific operations
if env.is_standalone() then
  map('n', '<leader>E', ':Explore<cr>')
  map('n', '<leader>V', ':vsp<cr>')
  map('n', '<leader>S', ':sp<cr>')
  map('n', '<leader>st', ':sp<cr>:term<cr>')
  map('n', '<leader>vt', ':vsp<cr>:term<cr>')
  map('n', '<leader>n', ':set hls!<cr>')
  map('n', '/', ':set hlsearch<cr>/')
  map('n', 'Q', ':w|bd<cr>')
end

-- VSCode-specific keybindings
if env.is_vscode() then
  -- Use VSCode's built-in commands for file operations
  map('n', '<leader>ff', '<cmd>call VSCodeNotify("workbench.action.quickOpen")<cr>')
  map('n', '<leader>fg', '<cmd>call VSCodeNotify("workbench.action.findInFiles")<cr>')
  map('n', '<leader>fb', '<cmd>call VSCodeNotify("workbench.action.showAllEditors")<cr>')
  
  -- Use VSCode's split commands
  map('n', '<leader>V', '<cmd>call VSCodeNotify("workbench.action.splitEditor")<cr>')
  map('n', '<leader>S', '<cmd>call VSCodeNotify("workbench.action.splitEditorDown")<cr>')
  
  -- Use VSCode's search
  map('n', '/', '<cmd>call VSCodeNotify("actions.find")<cr>')
end

return {
    map = map -- Export the map function for use in other modules
}
