local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "omnisharp"}

lspconfig["omnisharp"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "dotnet", "/home/codespace/.local/share/nvim/mason/packages/omnisharp/OmniSharp.dll"}
}

-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     cmd = { "dotnet", "/home/codespace/.local/share/nvim/mason/packages/omnisharp/OmniSharp.dll"}
--   }
-- end
