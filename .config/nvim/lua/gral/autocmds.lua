-- Disable auto-comment:
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions = { c = false, r = false, o = false }
    end,
})

-- Remember cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        -- Don't do this for gitcommit files:
        if vim.bo.filetype == "gitcommit" then
            return
        end
        vim.cmd([[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])
    end,
})
