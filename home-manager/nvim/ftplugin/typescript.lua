local navic = require("nvim-navic")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
lspconfig.tsserver.setup({
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end,
    capabilities = capabilities,
})
