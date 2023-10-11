-- Completion Plugin Setup
-- setup copilot support
-- require("copilot").setup({
--     suggestion = { enabled = false },
--     panel = { enabled = false },
-- })

local tabnine = require("cmp_tabnine.config")

tabnine:setup({
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = "..",
    ignored_file_types = {
        -- default is not to ignore
        -- uncomment to ignore in lua:
        -- lua = true
    },
    show_prediction_strength = false,
})
-- official tab nine
require("tabnine").setup({
    disable_auto_comment = true,
    -- accept_keymap = "<Tab>", -- don't conflict with cmp
    accept_keymap = "<F9>", -- don't conflict with cmp
    dismiss_keymap = "<C->",
    debounce_ms = 800,
    suggestion_color = { gui = "#808080", cterm = 244 },
    exclude_filetypes = { "TelescopePrompt" },
    log_file_path = nil, -- absolute path to Tabnine log file
})

-- github copilot
-- require("copilot_cmp").setup()

-- vscode like icons
local lspkind = require("lspkind")

local source_mapping = {
    buffer = "[Buffer]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[Lua]",
    cmp_tabnine = "[TN]",
    path = "[Path]",
}

local cmp = require("cmp")
cmp.setup({
    -- Enable LSP snippets
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        -- Add tab support
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<Tab>"] = cmp.mapping.select_next_item(),
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
        -- { name = "copilot" },-- github copilot support
        { name = "path" },                                       -- file paths
        { name = "nvim_lsp",               keyword_length = 3 }, -- from language server
        { name = "nvim_lsp_signature_help" },                    -- display function signatures with current parameter emphasized
        { name = "cmp_tabnine" },
        { name = "nvim_lua",               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
        { name = "buffer",                 keyword_length = 2 }, -- source current buffer
        { name = "vsnip",                  keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
        { name = "calc" },                                       -- source for math calculation
        { name = "crates" },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        format = function(entry, vim_item)
            -- if you have lspkind installed, you can use it like
            -- in the following line:
            vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol" })
            vim_item.menu = source_mapping[entry.source.name]
            if entry.source.name == "cmp_tabnine" then
                local detail = (entry.completion_item.labelDetails or {}).detail
                vim_item.kind = ""
                if detail and detail:find(".*%%.*") then
                    vim_item.kind = vim_item.kind .. " " .. detail
                end

                if (entry.completion_item.data or {}).multiline then
                    vim_item.kind = vim_item.kind .. " " .. "[ML]"
                end
            end
            local maxwidth = 80
            vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
            return vim_item
        end,
    },
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = "buffer" },
    }),
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
