local navic = require("nvim-navic")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig").html.setup({
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end,
    capabilities = capabilities,
    filetypes = { "html" },
    init_options = { "html", "css", "javascript" },
    embeddedLanguages = {
        css = true,
        javascript = true,
    },
    settings = {},
})
