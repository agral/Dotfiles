local function set_keymaps()
  local keymap_opts = {
    noremap = true,
    silent = true,
  }
  local kmap = vim.api.nvim_set_keymap

  kmap("n", "<leader>tfb", "<cmd>Telescope buffers<CR>", keymap_opts)
  kmap("n", "<leader>tff", "<cmd>Telescope find_files<CR>", keymap_opts)
  kmap("n", "<leader>tfg", "<cmd>Telescope live_grep<CR>", keymap_opts)
  kmap("n", "<leader>tfh", "<cmd>Telescope help_tags<CR>", keymap_opts)
end -- set_keymaps

set_keymaps()
