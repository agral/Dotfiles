local vks = function(trigger, mapping, description, mode_override)
    local mode = mode_override or "n"
    vim.keymap.set(mode, trigger, mapping, { desc = "LSP: " .. description, noremap = true, silent = true, })
end

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- configures Lua LSP, has good completion engine
            { "folke/neodev.nvim", opts={} },

            -- Status updates for the LSP
            { "j-hui/fidget.nvim", opts={} },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("gral-lsp-attach", {clear = true}),
                callback = function(event)
                    vks("<leader>ld", require("telescope.builtin").lsp_definitions, "go to definition")
                    vks("<leader>lD", vim.lsp.buf.declaration, "go to Declaration")
                    vks("<leader>lhd", vim.lsp.buf.declaration, "go to header declaration") -- aka "definition" that exists in the header file
                    vks("<leader>li", ":LspInfo<CR>", "LspInfo()")
                    vks("<leader>lr", require("telescope.builtin").lsp_references, "go to references")
                    vks("<leader>lgi", require("telescope.builtin").lsp_implementations, "go to implementations")
                    vks("<leader>ltd", require("telescope.builtin").lsp_type_definitions, "go to type definition")
                    vks("<leader>lds", require("telescope.builtin").lsp_document_symbols, "go to document symbols")
                    vks("<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "show workspace symbols")
                    vks("<leader>rn", vim.lsp.buf.rename, "rename")
                    vks("<leader>la", vim.lsp.buf.code_action, "apply quickfix code action")
                    vks("<M-CR>", vim.lsp.buf.code_action, "apply quickfix code action")
                    vks("K", vim.lsp.buf.hover, "Hover documentation")
                    vks("<leader>d", vim.diagnostic.open_float, "Show diagnostics for current line")
                    vks("<leader>dn", vim.diagnostic.goto_next, "Go to next diagnostic")
                    vks("<leader>dp", vim.diagnostic.goto_prev, "Go to previous diagnostic")
                    vks("<leader>dN", vim.diagnostic.goto_prev, "Go to previous diagnostic (alternative to <leader>dn)")

                    -- Highlight references of word-under-cursor when cursor rests over word for a little while.
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        local gral_lsp_highlight_augroup = vim.api.nvim_create_augroup("gral-lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
                            buffer = event.buf,
                            group = gral_lsp_highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
                            buffer = event.buf,
                            group = gral_lsp_highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })
                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("gral-lsp-detach", { clear = true }),
                            callback = function(detach_event)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ buffer = detach_event.buf, group = "gral-lsp-highlight", })
                            end,
                        })
                    end

                    -- Inlay hints: pretty intrusive, but sometimes helpful.
                    -- If provided, turn off by default, but provide a way to toggle them on/off.
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        vim.lsp.inlay_hint.enable(false)
                        local function toggle_inlay_hints()
                            local is_enabled = vim.lsp.inlay_hint.is_enabled()
                            vim.lsp.inlay_hint.enable(not is_enabled)
                        end
                        vks("<leader>lih", toggle_inlay_hints, "toggle inlay hints")
                    end

                end,
            })
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            local servers = {
                bashls = {},
                cssls = {},
                clangd = {},
                gopls = {},
                jsonls = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            -- diagnostics = { disable = { "missing-fields" } },
                        },
                    },
                },
                pyright = {},
                rust_analyzer = {},
            }
            -- Ensures that the servers and tools listed above are installed.
            local mason_is_good, mason = pcall(require, "mason")
            if not mason_is_good then
                vim.api.nvim_echo({
                    {"[Plugin error]", "Error"},
                    {"`mason` plugin is missing", "Normal"}
                }, true, {})
            end
            mason.setup({
                log_level = vim.log.levels.INFO,
                max_concurrent_installers = 4,
                ui = {
                    border = "rounded",
                },
            })

            local ensure_installed = vim.tbl_keys(servers or {})
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                automatic_installation = true,
                ensure_installed = ensure_installed,
                handlers = {
                    function(server_name)
                        local server_spec = servers[server_name] or {}
                        local is_customized, customization = pcall(require, "lsp_settings." .. server_name)
                        if is_customized then
                            server_spec = customization
                        end

                        server_spec.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_spec.capabilities or {})
                        require("lspconfig")[server_name].setup(server_spec)
                    end,
                },
            })
        end, -- config() for nvim-lspconfig
    },
}
