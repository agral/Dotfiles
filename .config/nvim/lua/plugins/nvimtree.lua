local vks = function(trigger, mapping, description, mode_override)
    local mode = mode_override or "n"
    vim.keymap.set(mode, trigger, mapping, { desc = description, noremap = true, silent = true, })
end

return {
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            local nvimtree_is_good, nvimtree = pcall(require, "nvim-tree")
            if not nvimtree_is_good then
              vim.api.nvim_echo({{"[setup error] ", "Error"}, {"nvim-tree plugin is missing", "Normal"}}, true, {})
              return
            end
            nvimtree.setup() -- use the defaults, these are fine.
            vks("<leader>e", ":NvimTreeToggle<CR>", "Show nvim-tree window")
        end,
    },
}
