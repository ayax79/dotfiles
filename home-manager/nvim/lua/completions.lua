-- Completion Plugin Setup
-- setup copilot support
require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
})

-- github copilot
require("copilot_cmp").setup()

-- vscode like icons
local lspkind = require("lspkind")

local cmp = require("cmp")
cmp.setup({
    view = {
        entries = {
            vertical_positioning = "above",
        },
    },
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
    sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- from language server
        -- { name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
        { name = "copilot" }
        -- { name = "buffer",                 keyword_length = 2 }, -- source current buffer
    }, {
        { name = "buffer" }, -- source current buffer
    }),
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            symbol_map = { Copilot = "" }
        }),
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
        { name = "nvim_lsp" },
        { name = "crates" },
    }, {
        { name = "buffer" },
    }),
})

-- cmp.setup.filetype("lua", {
--     sources = cmp.config.sources({
--         { name = "nvim_lua" },
--     }, {
--         { name = "buffer" },
--     }),
-- })
cmp.setup.filetype("lua", {
    sources = cmp.config.sources({
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "copilot" },
    }, { name = "buffer" }),
})
