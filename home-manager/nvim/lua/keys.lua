-- which key
local wk = require("which-key")
local telescope_builtin = require("telescope.builtin")
local neogit = require("neogit")
local noice = require("noice")

wk.add({
    -- Global Mappings
    { "[d",       vim.diagnostic.goto_prev,  desc = "Prev Diagnostic", },
    { "]d",       vim.diagnostic.goto_next,  desc = "Next Diagnostic", },
    { '<space>q', vim.diagnostic.setloclist, desc = "Set Loclist", },
    { "-",        "<CMD>Oil<CR>",            desc = "Open parent directory", },
    -- Find Group (Telescope)
    {
        "<leader>f",
        name = "Find",
        group = "Find",
        { "<leader>ff", telescope_builtin.find_files, desc = "Find File", },
        { "<leader>fg", telescope_builtin.live_grep,  desc = "Live Grep", },
        { "<leader>fb", telescope_builtin.buffers,    desc = "Find Buffer", },
        { "<leader>fk", telescope_builtin.keymaps,    desc = "Find Keymap", },
        { "<leader>fq", telescope_builtin.quickfix,   desc = "Find Quickfix", },
        { "<leader>fQ", telescope_builtin.quickfix,   desc = "Find Quickfix History", },
        { "<leader>fr", telescope_builtin.registers,  desc = "Find Register", },
        { "<leader>fG", telescope_builtin.git_files,  desc = "Find Git Files", },
        { "<leader>fs", telescope_builtin.git_status, desc = "Modified Git files", },
        { "<leader>fj", telescope_builtin.jumplist,   desc = "Jump List", },
    },
    -- Git Group
    {
        "<leader>g",
        name = "Git",
        group = "Git",
        { "<leader>gc", function() neogit.open({ "commit" }) end, desc = "Commit files", },
        { "<leader>gg", "<cmd>Lazygit<cr>",                       desc = "Lazy Git", },
        { "<leader>gf", telescope_builtin.git_files,              desc = "Find Git Files", },
        { "<leader>gn", neogit.open,                              desc = "Open Neogit", },
        { "<leader>gz", telescope_builtin.git_status,             desc = "Modified Git files (git_status)", },
        { "<leader>gl", telescope_builtin.git_commits,            desc = "Git commits log", },
        { "<leader>gZ", telescope_builtin.git_stash,              desc = "Git stash", },
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
        "<leader>ls",
        name = "LSP",
        group = "LSP",
        { "<leader>ls", telescope_builtin.lsp_document_symbols,  desc = "Document symbols", },
        { "<leader>lS", telescope_builtin.lsp_workspace_symbols, desc = "Workspace symbols", },
        { "<leader>ll", vim.lsp.codelens.run,                    desc = "CodeLens Action", },

    },
    --Debugger Group
    {
        "<leader>Db",
        name = "Debugger",
        group = "Debugger",
        { "<leader>Db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint", },
        { "<leader>Du", require("dapui").toggle,        desc = "Toggle Debugger UI", },
    },
    -- Noice Group
    {
        "<leader>nl",
        name = "Noice",
        group = "Noice",
        { "<leader>nl", function() noice.cmd("last") end,      desc = "Last Message", },
        { "<leader>nh", function() noice.cmd("history") end,   desc = "Message History", },
        { "<leader>nt", function() noice.cmd("telescope") end, desc = "Telescope", },
        { "<leader>nx", function() noice.cmd("dismiss") end,   desc = "Dismiss All Messages", },
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
        vim.keymap.set("n", "K", vim.lsp.buf.hover, util.with_description(opts, "LSP hover"))
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

        local exec_code_action = function()
            if vim.bo.filetype == 'rust' then
                vim.cmd.RustLsp('codeAction')
            else
                vim.lsp.buf.code_action()
            end
        end

        vim.keymap.set({ "n", "v" }, "<space>la", exec_code_action, util.with_description(opts, "Code Action"))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, util.with_description(opts, "Go to references"))
        vim.keymap.set("n", "<space>lf", function()
            vim.lsp.buf.format({ async = true })
        end, util.with_description(opts, "Format"))
        vim.keymap.set('n', '<space>lR', telescope_builtin.lsp_references, util.with_description(opts, "LSP references"))

        vim.keymap.set('v', 'M-K', require('dapui').eval, util.with_description(opts, "DAP Eval Expression"))
    end,
})

-- More Noice related keybindings
vim.keymap.set("c", "<S-Enter>", function()
    require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })

vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
    if not require("noice.lsp").scroll(4) then
        return "<c-f>"
    end
end, { silent = true, expr = true })

vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
    if not require("noice.lsp").scroll(-4) then
        return "<c-b>"
    end
end, { silent = true, expr = true })
