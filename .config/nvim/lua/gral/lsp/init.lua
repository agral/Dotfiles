-- custom mason configuration in lua/user/lsp/mason.lua:
require("gral.lsp.mason")
-- Note: this loads both mason and mason-lspconfig in the correct order.

-- custom handlers' configuration in lua/user/lsp/handlers.lua:
require("gral.lsp.handlers").setup()
