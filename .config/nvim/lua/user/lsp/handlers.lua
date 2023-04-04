local Handlers = {}

local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_ok then
  vim.api.nvim_echo({{"[setup error] ", "Error"}, {"cmp_nvim_lsp module is missing <lsp.handlers>", "Normal"}}, true, {})
  return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
Handlers.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

Handlers.setup = function()
  local diagnostic_config = {
    virtual_text = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }
  vim.diagnostic.config(diagnostic_config)
  vim.lsp.handlers["textDocument/hover"] =
      vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded",})
  vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded",})
end

local function lsp_keymaps(buf_num)
  local options = {noremap = true, silent = true,}
  --vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options)
  local kmap = vim.api.nvim_buf_set_keymap
  kmap(buf_num, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", options)
  kmap(buf_num, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", options)
  kmap(buf_num, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", options)
  kmap(buf_num, "n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", options)
  kmap(buf_num, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", options)

  kmap(buf_num, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", options)

  kmap(buf_num, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", options)
  kmap(buf_num, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", options)
  kmap(buf_num, "n", "<leader>li", "<cmd>LspInfo<cr>", options)
  kmap(buf_num, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", options)
  kmap(buf_num, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", options)
  kmap(buf_num, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", options)
  kmap(buf_num, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", options)
  kmap(buf_num, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", options)
  kmap(buf_num, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", options)
end

Handlers.on_attach = function(client, buf_num)
  lsp_keymaps(buf_num)
end

return Handlers
