local vks = function(trigger, mapping, description, mode_override)
    local mode = mode_override or "n"
    vim.keymap.set(mode, trigger, mapping, { desc = description, noremap = true, silent = true, })
end

return {
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable "make" == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_config = {
                        -- vertical = {width = 0.5},
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            -- Enable Telescope extensions, if installed:
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            local builtin = require("telescope.builtin")
            vks("<leader>sd", builtin.diagnostics, "Search in diagnostics")
            vks("<leader>sg", builtin.live_grep, "Search by grep")
            vks("<leader>sh", builtin.help_tags, "Search in help tags")
            vks("<leader>sk", builtin.keymaps, "Search in keymaps")
            vks("<leader>sn", function()
                builtin.find_files({cwd = vim.fn.stdpath "config"})
            end, "Search in Neovim config files")
            vks("<leader>so", builtin.oldfiles, "Search oldfiles - recently opened files")
            vks("<leader>sr", builtin.resume, "Search resume")
            vks("<leader>ss", builtin.builtin, "Search in select telescope")
            vks("<leader>sw", builtin.grep_string, "Search current word")
            vks('<leader>sf', builtin.find_files, "Search in project files")
        end,
    },
}
