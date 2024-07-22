vim.keymap.set("n", "<F3>", "<cmd>ClangdSwitchSourceHeader<CR>", {
    desc = "Switch between header and source files",
    noremap = true,
    silent = true,
})
