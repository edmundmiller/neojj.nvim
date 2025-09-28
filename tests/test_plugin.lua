local T = MiniTest.new_set()

T['module loads and exposes setup/open'] = function()
  local ok, M = pcall(require, 'neojj')
  MiniTest.expect.truthy(ok)
  MiniTest.expect.type_is(M, 'table')
  MiniTest.expect.type_is(M.setup, 'function')
  MiniTest.expect.type_is(M.open, 'function')
end

T[':NeoJJ command exists and runs without Neogit by mocking'] = function()
  -- Mock neogit backend to avoid external dependency
  package.loaded['neogit'] = { open = function(_) end }

  -- Command should be defined via plugin/neojj.lua on startup
  local commands = vim.api.nvim_get_commands({ builtin = false })
  MiniTest.expect.truthy(commands['NeoJJ'] ~= nil)

  -- Should not error when executed
  local ok = pcall(vim.cmd, 'NeoJJ')
  MiniTest.expect.truthy(ok)
end

return T