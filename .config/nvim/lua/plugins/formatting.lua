return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require("conform")
            conform.setup({
                formatters_by_ft = {
                    bash = { "beautysh" },
                    cpp = { "clang-format" },
                    go = { "gofmt" },

                    -- HTML and related languages:
                    html = { "prettierd", "prettier", stop_after_first = true },
                    css = { "prettierd", "prettier", stop_after_first = true },
                    scss = { "prettierd", "prettier", stop_after_first = true },

                    -- Javascript and related languages:
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                    json = { "prettierd", "prettier", stop_after_first = true },
                    typescript = { "prettierd", "prettier", stop_after_first = true },
                    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                    lua = { "stylua" },
                    proto = { "buf" },
                    yaml = { "yamlfix" }
                },
            })
            vim.keymap.set({ "n", "v" }, "<F12>", function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 500,
                })
            end, {
                desc = "Format entire file or the selected range",
                noremap = true,
                silent = true,
            })
        end,
    }
}
