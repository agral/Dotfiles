local vks = function(trigger, mapping, description, mode_override)
    local mode = mode_override or "n"
    vim.keymap.set(mode, trigger, mapping, { desc = description, noremap = true, silent = true, })
end

require("gral.options")
require("gral.keymaps")

--[[ SECTION: AUTOCOMMANDS --]]
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


--[[ SECTION: PLUGINS --]]
-- Automatically install lazy.nvim plugin manager:
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
    local lazy_addr = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({"git", "clone", "--filter=blob:none", lazy_addr, "--branch=stable", lazy_path })
    vim.api.nvim_echo({{"[setup info] ", "String"}, {"Lazy package manager installed. Please restart Neovim.", "Normal"}}, true, {})
end

vim.opt.rtp:prepend(lazy_path)

local is_good, lazy_plugin = pcall(require, "lazy")
if not is_good then
  vim.api.nvim_echo({{"[setup error] ", "Error"}, {"lazy.nvim module is missing", "Normal"}}, true, {})
  return
end

lazy_plugin.setup({
    { -- colorscheme
        "folke/tokyonight.nvim",
        lazy = false,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "-" },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },
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
                        vertical = {width = 0.5},
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
            vks('<leader>sf', builtin.find_files, "Search project files")
            vks("<leader>sh", builtin.help_tags, "Search in help tags")
            vks("<leader>sk", builtin.keymaps, "Search in keymaps")
            vks("<leader>ss", builtin.builtin, "Search in select telescope")
            vks("<leader>sw", builtin.grep_string, "Search current word")
            vks("<leader>sg", builtin.live_grep, "Search by grep")
            vks("<leader>sd", builtin.diagnostics, "Search in diagnostics")
            vks("<leader>sr", builtin.resume, "Search resume")
            vks("<leader>so", builtin.oldfiles, "Search oldfiles - recently opened files")
            vks("<leader>sn", function()
                builtin.find_files({cwd = vim.fn.stdpath "config"})
            end, "Search in Neovim config files")
        end, -- config() for telescope
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "folke/neodev.nvim", opts={} },

            -- Status updates for the LSP
            { "j-hui/fidget.nvim", opts={} },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("gral-lsp-attach", {clear = true}),
                callback = function(event)
                    local vks = function(trigger, action, desc)
                        vim.keymap.set("n", trigger, action, {buffer = event.buf, desc = "LSP: " .. desc})
                    end
                    local vkss = function(trigger, action, desc)
                        vim.keymap.set("n", trigger, action, {buffer = event.buf, silent = true, desc = "LSP: " .. desc})
                    end

                    vks("<leader>ld", require("telescope.builtin").lsp_definitions, "go to Definition")
                    vks("<leader>lD", vim.lsp.buf.declaration, "go to Declaration")
                    vks("<leader>lhd", vim.lsp.buf.declaration, "header declaration") -- aka definition that exists in the header file
                    vkss("<leader>li", ":LspInfo<CR>", "show LSP info")
                    vks("<leader>lr", require("telescope.builtin").lsp_references, "go to references")
                    vks("<leader>lgi", require("telescope.builtin").lsp_implementations, "go to implementations")
                    vks("<leader>ltd", require("telescope.builtin").lsp_type_definitions, "go to type definition")
                    vks("<leader>lds", require("telescope.builtin").lsp_document_symbols, "go to document symbols")
                    vks("<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
                    vks("<leader>rn", vim.lsp.buf.rename, "rename")
                    vks("<leader>la", vim.lsp.buf.code_action, "apply quickfix code action")
                    vks("<leader>K", vim.lsp.buf.hover, "Hover documentation")

                    -- Highlight references of word-under-cursor when cursor rests over word for a little while.
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end
            })
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
            local servers = {
                bashls = {},
                cssls = {},
                clangd = {},
                gopls = {},
                rust_analyzer = {},
                -- call `:help lspconfig-all` to see all the available preconfigured LSPs
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
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end, -- config() for nvim-lspconfig
    },
    -- Test this later:
    --{ "stevearc/conform.nvim",
    --},
    { -- Autocompletion engine
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "L3MON4D3/LuaSnip",
                build = (function()
                    -- This build step is needed for regex support in snippets.
                    if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
                dependencies = {
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    },
                },
            },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
        }, -- end of nvim-cmp's dependencies list
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})

            local nf_icons = {
              Class = "",
              Color = "",
              Constant = "",
              Constructor = "",
              Enum = "",
              EnumMember = "",
              Event = "",
              Field = "",
              File = "",
              Folder = "",
              Function = "",
              Interface = "",
              Keyword = "",
              Method = "m",
              Module = "",
              Operator = "",
              Property = "",
              Reference = "",
              Snippet = "",
              Struct = "",
              Text = "",
              TypeParameter = "",
              Unit = "",
              Value = "",
              Variable = "",
            }

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,noinsert"
                },
                formatting = {
                    expandable_indicator = true,
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        if vim.g.have_nerd_font then
                            vim_item.kind = nf_icons[vim_item.kind]
                        end
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip  = "[Snip]",
                            buffer   = "[Bffr]",
                            path     = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    -- `:h ins-completion`
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-g>"] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    ["<C-y>"] = cmp.mapping.confirm({ select = false }),
                    ["<C-Space>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expandable() then
                            luasnip.expand()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, {"i", "s"}),
                    ["<C-S-Space>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, {"i", "s"}),
                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sources = {
                    { name = "nvim-lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                },
                confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                },
                experimental = {
                    ghost_text = true,
                    native_menu = false,
                },
                window = {
                    documentation = {
                        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                    },
                },
            })
        end,
    },
    { -- Highlight TODO sections, etc.:
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false, },
    },
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
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            -- Valid entries: "all" / "maintained" / [list-of-languages]:
            ensure_installed = { "bash", "c", "html", "lua", "luadoc", "markdown", "vim", "vimdoc" },
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
            }, -- TODO: check whether this works all right.
            sync_install = false,
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = vim.g.have_nerd_font,
                    theme = "auto",
                    component_separators = { left = '', right = ''},
                    section_separators = { left = '', right = ''},
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'},
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {},
            })
        end,
    },
}, {
    ui = {
        -- if NF available, use empty array - it will be overridden. Otherwise define base Unicode icons:
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    }
}) -- end of lazy plugin setup
