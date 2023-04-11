local configs_ok, configs = pcall(require, "nvim-treesitter.configs")
if not configs_ok then
  vim.api.nvim_echo({{"[setup error] ", "Error"}, {"nvim-treesitter plugin is missing", "Normal"}}, true, {})
  return
end

configs.setup({
  -- Valid entries: "all" / "maintained" (parsers with active maintainers) / [list-of-languages]:
  ensure_installed = "all",
  highlight = {
    enable = true,
    disable = {""}, -- list of parsers that will not affect highlighting
    additional_vim_regex_highlighting = true,
  },
  ignore_install = {""}, -- list of parsers to completely ignore / not install
  indent = {
    enable = true,
    disable = {""}, -- list of parsers that will not affect indentation
  },
  sync_install = false,
})
