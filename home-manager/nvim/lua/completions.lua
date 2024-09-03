-- Completion Plugin Setup
-- setup copilot support
-- require("copilot").setup({
--     suggestion = { enabled = true },
--     panel = { enabled = true },
-- })
--
-- github copilot
-- require("copilot_cmp").setup()

-- vscode like icons
local lspkind = require("lspkind")

local cmp = require("cmp")
cmp.setup({
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
    },
    -- Installed sources:
    sources = {
        { name = "nvim_lsp",               keyword_length = 3 }, -- from language server
        { name = "nvim_lsp_signature_help" },                    -- display function signatures with current parameter emphasized
        { name = "buffer",                 keyword_length = 2 }, -- source current buffer
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = { --
        formatting = {
            format = lspkind.cmp_format({
                mode = "symbol_text",
                menu = {
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    nvim_lua = "[Lua]",
                    path = "[Path]",
                }
            }),
        },
    },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})

cmp.setup.filetype("toml", {
    sources = cmp.config.sources({
        { name = "crates" },
    }, {
        { name = "buffer" },
    }),
})

cmp.setup.filetype("lua", {
    sources = cmp.config.sources({
        { name = "nvim_lua" },
    }, {
        { name = "buffer" },
    }),
})
