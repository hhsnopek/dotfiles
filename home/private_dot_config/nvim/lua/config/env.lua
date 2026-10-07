-- Environment detection module
local M = {}

-- Detect if running in VSCode/Cursor
function M.is_vscode()
  return vim.g.vscode ~= nil
end

-- Detect if running standalone
function M.is_standalone()
  return not M.is_vscode()
end

-- Get environment type as string
function M.get_env()
  if M.is_vscode() then
    return "vscode"
  else
    return "standalone"
  end
end

return M 