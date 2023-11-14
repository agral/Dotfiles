local colorscheme = "tokyonight"
local is_good, _ = pcall(vim.cmd, string.format("colorscheme %s", colorscheme))

if not is_good then
  vim.cmd [[colorscheme default]]
  local warning = string.format("Colorscheme %s not found. Using default colorscheme.", colorscheme)
  vim.api.nvim_echo({{"[setup warning] ", "Error"}, {warning, "Normal"}}, true, {})
end

vim.cmd [[match errorMsg /\s\+$/]]
