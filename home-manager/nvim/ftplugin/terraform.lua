local navic = require("nvim-navic")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig").terraform_lsp.setup({
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end,
    capabilities = capabilities,
})

vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
