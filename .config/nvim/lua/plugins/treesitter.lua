return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            -- Valid entries: "all" / "maintained" / [list-of-languages]:
            ensure_installed = { "bash", "c", "cpp", "html", "lua", "luadoc", "markdown", "vim", "vimdoc" },
            --ensure_installed = "maintained",
            auto_install = true,
            highlight = {
                enable = true,
                disable = {}, -- list of parsers that will not affect highlighting
                additional_vim_regex_highlighting = { "ruby" },
            },
            ignore_install = {}, -- list of parsers to completely ignore and not install
            indent = {
                enable = true,
                disable = { "html", "ruby" },
            },
            sync_install = false,
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
