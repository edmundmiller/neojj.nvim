local T = MiniTest.new_set({ hooks = { pre_case = function()
  -- Close all floating windows before each test
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local cfg = vim.api.nvim_win_get_config(win)
    if cfg and cfg.relative ~= '' then pcall(vim.api.nvim_win_close, win, true) end
  end
end } })

local Hints = require('neojj.hints')

local function count_hint_windows()
  local count = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'neojj-hints' then
      count = count + 1
    end
  end
  return count
end

T['toggle creates and closes hints overlay'] = function()
  local bufnr = vim.api.nvim_create_buf(false, true)
  Hints.attach(bufnr, { { key = 'X', desc = 'Test' } }, { border = 'single' })

  MiniTest.expect.equality(count_hint_windows(), 0)

  Hints.toggle(bufnr)
  MiniTest.expect.equality(count_hint_windows(), 1)

  Hints.toggle(bufnr)
  MiniTest.expect.equality(count_hint_windows(), 0)
end

return T