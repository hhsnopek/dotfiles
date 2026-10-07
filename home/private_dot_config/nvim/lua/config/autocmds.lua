-- Create autocommand groups
local function augroup(name)
    return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- FileType-specific settings
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    group = augroup('filetypes'),
    callback = function()
        vim.keymap.set('v', '<Space>|', ':EasyAlign*<Bar><Enter>', { buffer = true })
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    group = augroup('markdown'),
    callback = function()
        vim.opt_local.list = true
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'gitcommit',
    group = augroup('git'),
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = 'en_us'
    end
})

-- Terminal settings
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    group = augroup('terminal'),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.spell = false
    end
})

-- Go specific settings
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    group = augroup('golang'),
    callback = function()
        require('go.format').goimports()
    end,
})

-- Colorscheme customization
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    group = augroup('colors'),
    callback = function()
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#ffffff', bg = '#333333' })
    end,
})
