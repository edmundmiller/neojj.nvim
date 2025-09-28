if vim.g.loaded_neojj then
  return
end
vim.g.loaded_neojj = true

vim.api.nvim_create_user_command("NeoJJ", function()
  require("neojj").open()
end, { desc = "Open Neogit with jjui-style UX overlays" })