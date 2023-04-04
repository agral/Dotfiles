local mason_is_good, mason = pcall(require, "mason")
if not mason_is_good then
  vim.api.nvim_echo({{"[setup error] ", "Error"}, {"mason module is missing", "Normal"}}, true, {})
  return
end

local masonLSP_is_good, masonLSP = pcall(require, "mason-lspconfig")
if not masonLSP_is_good then
  vim.api.nvim_echo({{"[setup error] ", "Error"}, {"mason-lspconfig module is missing", "Normal"}}, true, {})
  return
end

local lspconfig_is_good, lspconfig = pcall(require, "lspconfig")
if not lspconfig_is_good then
  vim.api.nvim_echo({{"[setup error] ", "Error"}, {"lspconfig module is missing", "Normal"}}, true, {})
  return
end

local mason_setup_settings = {
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}
mason.setup(mason_setup_settings)

local required_servers = {
}

local masonLsp_setup_settings = {
  ensure_installed = required_servers,
  automatic_installation = true,
}
masonLSP.setup(masonLsp_setup_settings)

local handlers = require("user.lsp.handlers")
for _, server_name in pairs(required_servers) do
  local opts = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities,
  }
  local server = vim.split(server_name, "@")[1]
  local server_is_good, server_config = pcall(require, string.format("user.lsp.settings.%s", server))
  if not server_is_good then
    vim.api.nvim_echo({
      {"[LSP server]", "SpellRare"},
      {string.format(" LSP configuration missing for %s", server), "Normal"}
    }, true, {})
  else
    opts = vim.tbl_deep_extend("force", server_config, opts)
  end

  lspconfig[server_name].setup(opts)
end
