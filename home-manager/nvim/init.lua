vim.g.theme_name = "nordic"

require("opts")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- the lazy package manager initialization and plugins are here
local plugins = require("plugins")
local lazy_opts = {
    install = {
        colorscheme = { vim.g.theme_name },
    },
}
require("lazy").setup(plugins, lazy_opts)

-- lsp configuration
require("lsp").setup()

-- code completion configuration
require("completions")

-- key mappings including which key
require("keys")
