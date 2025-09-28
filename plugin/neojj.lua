-- neojj.nvim plugin command definitions

-- Create the :NeoJJ command
vim.api.nvim_create_user_command('NeoJJ', function(args)
  local neojj = require('neojj')
  neojj.open(args.fargs and { args.fargs } or {})
end, {
  desc = 'Open NeoJJ interface',
  nargs = '*'
})