local nvimtree_is_good, nvimtree = pcall(require, "nvim-tree")
if not nvimtree_is_good then
  vim.api.nvim_echo({{"[setup error] ", "Error"}, {"cmp plugin is missing", "Normal"}}, true, {})
  return
end

nvimtree.setup({
})

vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", {noremap = true, silent = true})
