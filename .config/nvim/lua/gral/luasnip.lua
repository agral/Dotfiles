--[[ Possible future setup:
local snippets_path = vim.fn.stdpath("config") .. "/snippets/"
require("luasnip.loaders.from_vscode").load({
  paths = snippets_path,
})
--]]

local luasnip_is_good, luasnip = pcall(require, "luasnip")
if not luasnip_is_good then
  vim.api.nvim_echo({{"[setup error] ", "Error"}, {"luasnip plugin is missing", "Normal"}}, true, {})
  return
end
local types = require "luasnip.util.types"

luasnip.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,

  ext_opts = nil,
})

return {}
