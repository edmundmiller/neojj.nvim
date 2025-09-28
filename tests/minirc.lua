-- Minimal Neovim config for running MiniTest-based tests
-- Adjust runtimepath to include the plugin under test and mini.nvim (vendor path in CI)

if vim.loader and vim.loader.enable then
  pcall(vim.loader.enable)
end

local cwd = vim.fn.getcwd()
local plugin_root = cwd
local vendor_mini = plugin_root .. "/tests/vendor/mini.nvim"

-- Prepend test vendor mini.nvim if present (CI clones it)
if vim.fn.isdirectory(vendor_mini) == 1 then
  vim.opt.rtp:prepend(vendor_mini)
end

-- Prepend plugin root so `plugin/` and `lua/` are discoverable
vim.opt.rtp:prepend(plugin_root)

-- Sensible defaults for headless testing
vim.o.swapfile = false
vim.o.shada = ""
vim.o.shortmess = vim.o.shortmess .. "I"
vim.o.more = false
vim.o.hidden = true

-- Load MiniTest
local ok, MiniTest = pcall(require, "mini.test")
if not ok then
  error("mini.test not found in runtimepath. Ensure tests/vendor/mini.nvim exists.")
end

-- Expose globally for :lua MiniTest.run()
_G.MiniTest = MiniTest