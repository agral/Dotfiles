local gitsigns_is_good, gitsigns = pcall(require, "gitsigns")
if not gitsigns_is_good then
  vim.api.nvim_echo({{"[setup error] ", "Error"}, {"gitsigns plugin is missing", "Normal"}}, true, {})
  return
end

gitsigns.setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
})
