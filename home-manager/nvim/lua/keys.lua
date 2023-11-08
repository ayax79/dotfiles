-- which key
local wk = require("which-key")
local telescope_builtin = require("telescope.builtin")
local neogit = require("neogit")
local noice = require("noice")

wk.register({
    f = {
        name = "Find",                                     -- optional group name
        f = { telescope_builtin.find_files, "Find File" }, -- create a binding with label
        g = { telescope_builtin.live_grep, "Live Grep" },
        b = { telescope_builtin.buffers, "Find Buffer" },
        k = { telescope_builtin.keymaps, "Find Keymap" },
        q = { telescope_builtin.quickfix, "Find Quickfix" },
        r = { telescope_builtin.registers, "Find Register" },
        G = { telescope_builtin.git_files, "Find Git Files" },
        s = { telescope_builtin.git_status, "Modified Git files" },
        j = { telescope_builtin.jumplist, "Jump List" },
    },
    g = {
        name = "git",
        c = { function() neogit.open({ "commit" }) end, "Commit files" },
        g = { "<cmd>Lazygit<cr>", "Lazy Git" },
        f = { telescope_builtin.git_files, "Find Git Files" },
        n = { neogit.open, "Open Neogit" },
        z = { telescope_builtin.git_status, "Modified Git files (git_status)" },
        l = { telescope_builtin.git_commits, "Git commits log" },
        Z = { telescope_builtin.git_stash, "Git stash" },
    },
    m = {
        name = "Bookmarks",
        m = { "<Cmd>BookmarkToggle<CR>", "Toggle bookmark" },
        i = { "<Cmd>BookmarkAnnotate<CR>", "Annotate bookmark" },
        n = { "<Cmd>BookmarkNext<CR>", "Jump to next bookmark in buffer" },
        p = { "<Cmd>BookmarkPrev<CR>", "Jump to previous bookmark in buffer" },
        a = { "<Cmd>BookmarkShowAll<CR>", "Show all bookmarks (toggle)" },
        c = { "<Cmd>BookmarkClear<CR>", "Clear bookmarks in current buffer" },
        x = { "<Cmd>BookmarkClearAll<CR>", "Clear bookmarks in all buffers" },
        f = { "<Cmd>Telescope vim_bookmarks current_file<CR>", "Find bookmark (current file)" },
        F = { "<Cmd>Telescope vim_bookmarks all<CR>", "Find bookmark (all files)" },
    },
    e = { "<cmd>NvimTreeToggle<cr>", "Toggle Nvim Tree" },
    x = {
        name = "Trouble plugin options",
        x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
        w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Toggle trouble workspace diagnostics" },
        d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Toggle trouble document diagnostics" },
        l = { "<cmd>TroubleToggle loclist<cr>", "Toggle trouble loclist" },
        q = { "<cmd>TroubleToggle quickfix<cr>", "Toggle trouble quickfix" },
        R = { "<cmd>TroubleToggle lsp_references<cr>", "Toggle trouble lsp references" },
    },
    b = {
        name = "Buffers",
        f = { telescope_builtin.buffers, "Find Buffer" },
        b = { "<Cmd>BufferOrderByBufferNumber<CR>", "Order buffers by number" },
        d = { "<Cmd>BufferOrderByDirectory<CR>", "Order buffers by directory" },
        l = { "<Cmd>BufferOrderByLanguage<CR>", "Order buffers by Language" },
        w = { "<Cmd>BufferOrderByWindowNumber<CR>", "Order buffers by window number" },
    },
    l = {
        name = "LSP",
        s = { telescope_builtin.lsp_document_symbols, "Document symbols" },
        S = { telescope_builtin.lsp_workspace_symbols, "Workspace symbols" },
        l = { vim.lsp.codelens.run, "CodeLens Action" },
        D = {
            name = "Debugger",
            b = { "<cmd>DapToggleBreakpoint<cr>", "Toggle breakpoint" },
            u = { require("dapui").toggle, "Toggle Debugger UI" },
        },
        t = { "<cmd>TroubleToggle lsp_type_definitions<cr>", "Type Definitions (trouble)" },
        d = { "<cmd>TroubleToggle lsp_definitions<cr>", "Definitions (trouble)" },
    },
    t = {
        name = "Terminal",
        h = { "<cmd>ToggleTerm size=40 direction=horizontal<cr>", "Toggle terminal (horizontal)" },
        v = { "<cmd>ToggleTerm size=120 direction=vertical<cr>", "Toggle terminal (vertical)" },
        f = { "<cmd>ToggleTerm direction=float<cr>", "Toggle terminal (floating)" },
        a = { "<cmd>ToggleTermToggleAll<cr>", "Toggle all terminals" },
    },
    h = {
        name = "Harpoon",
        a = { require("harpoon.mark").add_file, "Add file" },
        t = { "<cmd>:Telescope harpoon marks<cr>", "Telescope" },
        q = { require('harpoon.ui').toggle_quick_menu, "Quick Menu" },
        r = { require("harpoon.mark").remove_file, "Remove file" },
        x = { require("harpoon.mark").add_file, "Clear all files" },
    },
    n = {
        name = "Noice",
        l = { function() noice.cmd("last") end, "Last Message" },
        h = { function() noice.cmd("history") end, "Message History" },
        t = { function() noice.cmd("telescope") end, "Telescope" },
        x = { function() noice.cmd("dismiss") end, "Dismiss All Messages" },

    }
}, { prefix = "<leader>" })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = "Set Loclist" })


vim.keymap.set("n", "[h", require("harpoon.ui").nav_prev, { desc = "Prev Harpoon mark" })
vim.keymap.set("n", "]h", require("harpoon.ui").nav_next, { desc = "Next Hapoon mark" })
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
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, util.with_description(opts, "Go to Declaration"))
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, util.with_description(opts, "Go to definition"))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, util.with_description(opts, "LSP hover"))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, util.with_description(opts, "Go to implementation"))
        vim.keymap.set("n", "<M-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end, util.with_description(opts, "Lsp References"))
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
        vim.keymap.set({ "n", "v" }, "<space>la", vim.lsp.buf.code_action, util.with_description(opts, "Code Action"))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, util.with_description(opts, "Go to references"))
        vim.keymap.set("n", "<space>lf", function()
            vim.lsp.buf.format({ async = true })
        end, util.with_description(opts, "Format"))
        vim.keymap.set('n', '<space>lR', telescope_builtin.lsp_references, util.with_description(opts, "LSP references"))
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
