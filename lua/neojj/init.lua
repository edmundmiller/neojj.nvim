-- neojj.nvim - A jj (Jujutsu) frontend for Neovim
local M = {}

M.config = {
  -- Default configuration options can go here
}

-- Setup function for configuring the plugin
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Open neojj interface (delegates to Neogit for now)
function M.open(opts)
  opts = opts or {}
  local ok, neogit = pcall(require, "neogit")
  if not ok then
    vim.notify("neojj.nvim requires Neogit to be installed", vim.log.levels.ERROR)
    return
  end
  neogit.open(opts)
end

return M