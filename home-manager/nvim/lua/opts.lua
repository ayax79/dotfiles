-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.wo.relativenumber = true
vim.wo.number = true
-- vim.o.statuscolumn = "%s %l %=%{v:relnum?v:relnum:v:lnum} "
-- vim.wo.colorcolumn = "120"

-- maintain undo history between sessions
vim.cmd([[
set undofile
]])

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

-- default tab settings
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- white space settings
vim.opt.list = true
vim.opt.listchars:append("eol:↴")
vim.opt.listchars:append("space:⋅")

-- set termguicolors to enable highlight groups

-- git blame off by default
vim.g.gitblame_enabled = 0

vim.filetype.add({
    extension = {
        avsc = "json",
    }
})

vim.o.cursorline = true

vim.o.conceallevel = 2
