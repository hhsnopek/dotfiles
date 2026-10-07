-- Floating cheatsheet of custom keymaps. Toggled by <leader>?.
-- Add/remove entries in `entries` below; `section = '...'` rows start a group.

local M = {}

local entries = {
  { section = 'Windows / Tabs' },
  { '<leader>j/k/l/h', 'Move between split windows' },
  { '<Tab>l / <Tab>h', 'Next / previous tab' },
  { '<leader>V',       'Vertical split' },
  { '<leader>S',       'Horizontal split' },
  { '<leader>vt',      'Vertical split + open terminal' },
  { '<leader>st',      'Horizontal split + open terminal' },

  { section = 'Files / Search' },
  { '<leader>ff',      'Telescope: find files' },
  { '<leader>fg',      'Telescope: live grep' },
  { '<leader>fb',      'Telescope: buffers' },
  { '<leader>fh',      'Telescope: help tags' },
  { '<leader>E',       'Open netrw file explorer' },

  { section = 'Editing' },
  { '<leader>w',       'Toggle line wrap' },
  { '<leader>n',       'Toggle search highlight' },
  { 'Q',               'Save and close buffer' },
  { 'gcc / gc{motion}', 'Toggle line / motion comment (built-in)' },

  { section = 'Folding (treesitter)' },
  { 'za',              'Toggle fold under cursor' },
  { 'zR',              'Open all folds' },
  { 'zM',              'Close all folds' },

  { section = 'LSP (when a server is attached)' },
  { 'gd',              'Go to definition' },
  { 'gD',              'Go to declaration (if supported)' },
  { 'gi',              'Go to implementation' },
  { 'gr',              'Find references' },
  { 'K',               'Hover documentation (markdown-rendered)' },
  { '<C-k>',           'Signature help' },
  { '<space>rn',       'Rename symbol' },
  { '<space>ca',       'Code action' },
  { '<space>f',        'Format buffer' },
  { '<space>D',        'Go to type definition' },
  { '<space>wa/wr/wl', 'Workspace folder add / remove / list' },
  { '<leader>ih',      'Toggle inlay hints' },

  { section = 'Completion / Snippets' },
  { '<C-x><C-o>',      'Trigger LSP completion manually' },
  { '<C-n> / <C-p>',   'Next / previous completion item' },
  { '<C-y>',           'Accept completion (expands snippets)' },
  { '<Tab> / <S-Tab>', 'Jump to next / previous snippet placeholder' },

  { section = 'Diagnostics' },
  { '<space>e',        'Open floating diagnostic' },
  { '[d / ]d',         'Previous / next diagnostic' },
  { '<space>q',        'Send diagnostics to loclist' },

  { section = 'Terminal mode' },
  { ',j / ,k / ,l / ,h', 'Window navigation from terminal' },
  { ',tq',             'Close current tab' },
  { '<esc>',           'Exit terminal mode (to normal)' },
  { '<C-\\>',          'Send literal <esc> through terminal' },

  { section = 'Help' },
  { '<leader>?',       'Toggle this cheatsheet (q / <esc> to close)' },
}

local state = { win = nil, buf = nil }

local function build_lines()
  local max_lhs = 0
  for _, e in ipairs(entries) do
    if not e.section and #e[1] > max_lhs then max_lhs = #e[1] end
  end

  local lines = {}
  for _, e in ipairs(entries) do
    if e.section then
      if #lines > 0 then table.insert(lines, '') end
      table.insert(lines, e.section)
      table.insert(lines, string.rep('─', vim.fn.strdisplaywidth(e.section)))
    else
      table.insert(lines, string.format('  %-' .. max_lhs .. 's  %s', e[1], e[2]))
    end
  end
  return lines
end

local function close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win, state.buf = nil, nil
end

function M.show()
  local lines = build_lines()

  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  width = math.min(width + 4, vim.o.columns - 4)
  local height = math.min(#lines, vim.o.lines - 6)

  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false
  vim.bo[state.buf].bufhidden = 'wipe'
  vim.bo[state.buf].filetype = 'cheatsheet'

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' keymaps ',
    title_pos = 'center',
  })

  vim.wo[state.win].cursorline = true
  vim.wo[state.win].winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder'

  vim.keymap.set('n', 'q', close, { buffer = state.buf, silent = true, nowait = true })
  vim.keymap.set('n', '<esc>', close, { buffer = state.buf, silent = true, nowait = true })

  -- Close if cursor leaves the window (e.g. user clicks elsewhere)
  vim.api.nvim_create_autocmd('WinLeave', {
    buffer = state.buf,
    once = true,
    callback = close,
  })
end

function M.toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    close()
  else
    M.show()
  end
end

return M
