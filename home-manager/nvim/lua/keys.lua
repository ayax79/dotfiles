-- which key
local wk = require("which-key")
local telescope_builtin = require("telescope.builtin")
local crates = require("crates");

-- BEGIN HARPOON
local harpoon = require('harpoon')
-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end
-- END HARPOON

-- START MULTICURSOR
local mc = require("multicursor-nvim")
mc.setup()

-- use MultiCursorCursor and MultiCursorVisual to customize
-- additional cursors appearance
vim.cmd.hi("link", "MultiCursorCursor", "Cursor")
vim.cmd.hi("link", "MultiCursorVisual", "Visual")

-- END MULTICURSOR

-- add cursors above/below the main cursor

wk.add({
    -- Global Mappings
    -- { "[d",       vim.diagnostic.goto_prev,  desc = "Prev Diagnostic", },
    { "[d",       "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Prev Diagnostic", },
    -- { "]d",       vim.diagnostic.goto_next,  desc = "Next Diagnostic", },
    { "]d",       "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next Diagnostic", },
    { '<space>q', vim.diagnostic.setloclist,               desc = "Set Loclist", },
    { "-",        "<CMD>Oil<CR>",                          desc = "Open parent directory", },

    -- Multi-cursor support
    { "<esc>", function()
        if mc.hasCursors() then
            mc.clearCursors()
        else
            -- default <esc> handler
        end
    end },

    { "<up>",          function() mc.addCursor("k") end,  mode = { "n", "v" } },
    { "<down>",        function() mc.addCursor("j") end,  mode = { "n", "v" } },
    -- add a cursor and jump to the next word under cursor
    { "<c-n>",         function() mc.addCursor("*") end,  mode = { "n", "v" } },
    -- jump to the next word under cursor but do not add a cursor
    { "<c-s>",         function() mc.skipCursor("*") end, mode = { "n", "v" } },

    -- rotate the main cursor
    { "<left>",        function() mc.nextCursor() end,    mode = { "n", "v" } },
    { "<right>",       function() mc.prevCursor() end,    mode = { "n", "v" } },

    -- delete the main cursor
    { "<leader>e",     function() mc.deleteCursor() end,  mode = { "n", "v" } },

    -- add and remove cursors with control + left click
    { "<c-leftmouse>", mc.handleMouse, },

    -- Find Group (Telescope)
    {
        "<leader>f",
        name = "Find",
        group = "Find",
        { "<leader>ff", telescope_builtin.find_files,                desc = "Find File", },
        { "<leader>fg", telescope_builtin.live_grep,                 desc = "Live Grep", },
        { "<leader>fb", telescope_builtin.buffers,                   desc = "Find Buffer", },
        { "<leader>fd", require("telescope").extensions.zoxide.list, desc = "Find Directory", },
        { "<leader>fk", telescope_builtin.keymaps,                   desc = "Find Keymap", },
        { "<leader>fq", telescope_builtin.quickfix,                  desc = "Find Quickfix", },
        { "<leader>fQ", telescope_builtin.quickfix,                  desc = "Find Quickfix History", },
        { "<leader>fr", telescope_builtin.registers,                 desc = "Find Register", },
        { "<leader>fG", telescope_builtin.git_files,                 desc = "Find Git Files", },
        { "<leader>fs", telescope_builtin.git_status,                desc = "Modified Git files", },
        { "<leader>fj", telescope_builtin.jumplist,                  desc = "Jump List", },
    },
    -- Git Group
    {
        "<leader>g",
        name = "Git",
        group = "Git",
        { "<leader>gg", "<cmd>Lazygit<cr>",            desc = "Lazy Git", },
        { "<leader>gf", telescope_builtin.git_files,   desc = "Find Git Files", },
        { "<leader>gz", telescope_builtin.git_status,  desc = "Modified Git files (git_status)", },
        { "<leader>gl", telescope_builtin.git_commits, desc = "Git commits log", },
        { "<leader>gZ", telescope_builtin.git_stash,   desc = "Git stash", },
    },
    -- Bookmarks Group
    {
        "<leader>m",
        name = "Bookmarks",
        group = "Bookmarks",
        { "<leader>mm", "<Cmd>BookmarkToggle<CR>",                       desc = "Toggle bookmark", },
        { "<leader>mi", "<Cmd>BookmarkAnnotate<CR>",                     desc = "Annotate bookmark", },
        { "<leader>mn", "<Cmd>BookmarkNext<CR>",                         desc = "Jump to next bookmark in buffer", },
        { "<leader>mp", "<Cmd>BookmarkPrev<CR>",                         desc = "Jump to previous bookmark in buffer", },
        { "<leader>ma", "<Cmd>BookmarkShowAll<CR>",                      desc = "Show all bookmarks (toggle)", },
        { "<leader>mc", "<Cmd>BookmarkClear<CR>",                        desc = "Clear bookmarks in current buffer", },
        { "<leader>mx", "<Cmd>BookmarkClearAll<CR>",                     desc = "Clear bookmarks in all buffers", },
        { "<leader>mf", "<Cmd>Telescope vim_bookmarks current_file<CR>", desc = "Find bookmark (current file)", },
        { "<leader>mF", "<Cmd>Telescope vim_bookmarks all<CR>",          desc = "Find bookmark (all files)", },
    },
    -- Buffers Group
    {
        "<leader>b",
        name = "Buffers",
        group = "Buffers",
        { "<leader>bf", telescope_builtin.buffers,            desc = "Find Buffer", },
        { "<leader>bb", "<Cmd>BufferOrderByBufferNumber<CR>", desc = "Order buffers by number", },
        { "<leader>bd", "<Cmd>BufferOrderByDirectory<CR>",    desc = "Order buffers by directory", },
        { "<leader>bl", "<Cmd>BufferOrderByLanguage<CR>",     desc = "Order buffers by Language", },
        { "<leader>bw", "<Cmd>BufferOrderByWindowNumber<CR>", desc = "Order buffers by window number", },
    },
    -- LSP Group
    {
        "<leader>l",
        name = "LSP",
        group = "LSP",
        { "<leader>ls", telescope_builtin.lsp_document_symbols,  desc = "Document symbols", },
        { "<leader>lS", telescope_builtin.lsp_workspace_symbols, desc = "Workspace symbols", },
        { "<leader>ll", vim.lsp.codelens.run,                    desc = "CodeLens Action", },
        { "<leader>lp", "<cmd>Lspsaga peek_definition<cr>",      desc = "Peek Definition", },
        { "<leader>lo", "<cmd>Lspsaga outline<cr>",              desc = "Outline", },
        --Debugger Group
        {
            "<leader>lD",
            name = "Debugger",
            group = "Debugger",
            { "<leader>lDb", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint", },
            { "<leader>lDu", require("dapui").toggle,        desc = "Toggle Debugger UI", },
        },
    },
    { "<leader>T", "<cmd>Lspsaga  term_toggle<cr>", group = "Term", desc = "Togggle Term", },
    -- Trouble Group
    {
        "<leader>x",
        name = "Trouble",
        group = "Trouble",
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            "<leader>xs",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>xl",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
            "<leader>xL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<leader>xQ",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },
    },
    -- Crates Group
    {
        "<leader>c",
        name = "Crates",
        group = "Crates",
        { "<leader>ct", crates.toggle,                             desc = "Crates Toggle" },
        { "<leader>cr", crates.reload,                             desc = "Crates Reload" },
        { "<leader>cv", crates.show_versions_popup,                desc = "Show Versions Popup" },
        { "<leader>cf", crates.show_features_popup,                desc = "Show Features Popup" },

        { "<leader>cu", crates.update_crate,                       desc = "Update Crate" },
        { "<leader>cs", crates.update_crates,                      desc = "Update Crates" },
        { "<leader>ca", crates.update_all_crates,                  desc = "Update All Crates" },
        { "<leader>cU", crates.upgrade_crate,                      desc = "Upgrade Crate" },
        { "<leader>cS", crates.upgrade_crates,                     desc = "Upgrade Crates" },
        { "<leader>cA", crates.upgrade_all_crates,                 desc = "Upgrade All Crates" },

        { "<leader>cx", crates.expand_plain_crate_to_inline_table, desc = "Expand crate to inline table" },
        { "<leader>cX", crates.extract_crate_into_table,           desc = "Extract crate into table" },

        { "<leader>cH", crates.open_homepage,                      desc = "Open Homepage" },
        { "<leader>cR", crates.open_repository,                    desc = "Open Repository" },
        { "<leader>cD", crates.open_documentation,                 desc = "Open Documentation" },
        { "<leader>cC", crates.open_crates_io,                     desc = "Open Crates IO" },
    },
    -- Harpoon Group
    {
        "<leader>h",
        name = "Harpooon",
        group = "Harpooon",
        { "<leader>hf", function() toggle_telescope(harpoon:list()) end,             desc = "Telescope" },
        { "<leader>ha", function() harpoon:list():add() end,                         desc = "Add File" },
        { "<leader>hq", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Quicklist" },
        { "<leader>hr", function() harpoon:list():remove() end,                      desc = "Remove Current File" },
        { "<leader>h1", function() harpoon:list():select(1) end,                     desc = "Select Item 1" },
        { "<leader>h2", function() harpoon:list():select(2) end,                     desc = "Select Item 2" },
        { "<leader>h3", function() harpoon:list():select(3) end,                     desc = "Select Item 3" },
        { "<leader>h4", function() harpoon:list():select(4) end,                     desc = "Select Item 4" },
        { "[h",         function() harpoon:list():prev() end,                        desc = "Harpoon Prev" },
        { "]h",         function() harpoon:list():next() end,                        desc = "Harpoon Next" },
    },
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
--
local util = require("util")

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, util.with_description(opts, "Go to Declaration"))
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, util.with_description(opts, "Go to definition"))
        -- vim.keymap.set("n", "K", vim.lsp.buf.hover, util.with_description(opts, "LSP hover"))
        vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", util.with_description(opts, "DOC"))
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, util.with_description(opts, "Go to implementation"))
        vim.keymap.set("n", "<M-k>", vim.lsp.buf.signature_help, util.with_description(opts, "Signature Help"))
        vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end,
            util.with_description(opts, "Lsp References"))
        vim.keymap.set("n", "gx", vim.lsp.buf.incoming_calls, util.with_description(opts, "Go to incoming calls"))
        vim.keymap.set("n", "gX", vim.lsp.buf.outgoing_calls, util.with_description(opts, "Go to outgoing calls"))
        vim.keymap.set(
            "n",
            "<space>wa",
            vim.lsp.buf.add_workspace_folder,
            util.with_description(opts, "Add workspace folder")
        )
        vim.keymap.set(
            "n",
            "<space>wr",
            vim.lsp.buf.remove_workspace_folder,
            util.with_description(opts, "Remove workspace folder")
        )
        vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, util.with_description(opts, "List workspace folders"))
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, util.with_description(opts, "Type definition"))
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)

        -- local exec_code_action = function()
        --     if vim.bo.filetype == 'rust' then
        --         vim.cmd.RustLsp('codeAction')
        --     else
        --         vim.lsp.buf.code_action()
        --     end
        -- end

        --vim.keymap.set({ "n", "v" }, "<space>la", exec_code_action, util.with_description(opts, "Code Action"))
        vim.keymap.set({ "n", "v" }, "<space>la", "<cmd>Lspsaga code_action<cr>",
            util.with_description(opts, "Code Action"))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, util.with_description(opts, "Go to references"))
        vim.keymap.set("n", "<space>lf", function()
            vim.lsp.buf.format({ async = true })
        end, util.with_description(opts, "Format"))
        vim.keymap.set('n', '<space>lR', telescope_builtin.lsp_references, util.with_description(opts, "LSP references"))

        vim.keymap.set('v', 'M-K', require('dapui').eval, util.with_description(opts, "DAP Eval Expression"))
    end,
})
