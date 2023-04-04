--[[ Possible future setup:
local snippets_path = vim.fn.stdpath("config") .. "/snippets/"
require("luasnip.loaders.from_vscode").load({
  paths = snippets_path,
})
--]]

return {}
