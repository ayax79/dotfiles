M = {}

--------------------------------------------------------
--- THEME, UI, & VISUALS
--------------------------------------------------------
if vim.g.theme_name == "nord" then
    table.insert(M, {
        "shaunsingh/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- Example config in lua
            vim.g.nord_contrast = true
            vim.g.nord_borders = true
            vim.g.nord_disable_background = false
            vim.g.nord_italic = false
            vim.g.nord_uniform_diff_background = true
            vim.g.nord_bold = false

            -- Load the colorscheme
            require('nord').set()
        end
    })
elseif vim.g.theme_name == "nordic" then
    table.insert(M,
        {
            'AlexvZyl/nordic.nvim',
            lazy = false,
            priority = 1000,
            config = function()
                require 'nordic'.load()
            end
        })
elseif vim.g.theme_name == "onenord" then
    table.insert(M,
        {
            'rmehri01/onenord.nvim',
            lazy = false,
            priority = 1000,
            config = function()
                require 'onenord'.setup()
            end
        })
end

table.insert(M, {

    --------------------------------------------------------
    --- COMMON LIBRARIES & EDITOR FUNCTIONALITY
    --------------------------------------------------------

    -- a common library of utilities
    "nvim-lua/plenary.nvim",
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    -- Provides a useable key binding library
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },
    -- Configurations and extraction layer for the treesitter parsing tool
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            -- Treesitter Plugin Setup
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "rust", "toml", "markdown", "markdown_inline", "regex", "nu", "go" },
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { "markdown" },
                },
                ident = { enable = true },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = nil,
                },
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = vim.g.theme_name,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = true,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = {
                        {
                            "filename",
                            file_status = true,
                            path = 3,
                            shorting_target = 40,
                        },
                    },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {},
            })
        end,
    },
    {
        'nvimdev/lspsaga.nvim',
        event = "LspAttach",
        config = function()
            require('lspsaga').setup({
                lightbulb = {
                    -- Don't show lightbulb in the status column... causes it to bounce
                    sign = false,
                },
                diagnostic = {
                    keys = {
                        quit = '<ESC>',
                    },
                },
                code_action = {
                    keys = {
                        quit = '<ESC>',
                    },
                },
                definition = {
                    keys = {
                        quit = '<ESC>',
                    },
                },
            })
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons',     -- optional
        }
    },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
    },
    -- Provides a betterquick fix and lsp diagnostics list
    "nvim-telescope/telescope-ui-select.nvim",
    -- Visual Search for files, quickfix, etc
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            -- local actions = require("telescope.actions")
            local open_with_trouble = require("trouble.sources.telescope").open

            -- Use this to add more results without clearing the trouble list
            -- local add_to_trouble = require("trouble.sources.telescope").add

            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = { ["<c-t>"] = open_with_trouble },
                        n = { ["<c-t>"] = open_with_trouble },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({
                            -- even more opts
                        }),
                    },
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    },
                    zoxide = {
                        prompt_title = "[ Find directory ]", -- Any title you like
                        mappings = {
                            default = {
                                -- telescope-zoxide will change directory.
                                -- But I'm only using it to get selection.path from telescope UI.
                                after_action = function(selection)
                                    vim.cmd("Oil " .. selection.path)
                                    vim.api.nvim_feedkeys("_", "", false)
                                end,
                            },
                        },
                    },
                },
            })

            telescope.load_extension("ui-select")
            telescope.load_extension("zoxide")
        end,
    },
    -- bookmark support
    "MattesGroeger/vim-bookmarks",
    -- search bookmarks in telescope
    "tom-anders/telescope-vim-bookmarks.nvim",
    "jvgrootveld/telescope-zoxide",
    -- native fzf support
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
    -- project support
    {
        "ahmedkhalf/project.nvim",
        lazy = false,
        config = function()
            require("project_nvim").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
                patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "gradlew", "Cargo.toml" },
            })
        end,
    },
    -- provides automatically closing brackets
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        lazy = false,
        opts = {}, -- this is equalent to setup({}) function
    },
    -- handy keybindings
    "tpope/vim-unimpaired",
    -- illuminates all instances that is selected
    "RRethy/vim-illuminate",

    -- Provides smart support for comments
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },
    ---------------------------------------------------------
    --- GIT SUPPORT
    --------------------------------------------------------

    -- Shows git status in the left gutter
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map('n', ']c', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, { expr = true, desc = 'Next uncommitted change' })

                    map('n', '[c', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, { expr = true, desc = 'Previous uncommitted change' })

                    -- Actions
                    map('n', '<leader>gs', gs.stage_hunk, { desc = 'State Hunk' })
                    map('n', '<leader>gr', gs.reset_hunk, { desc = 'Reset Hunk' })
                    map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                        { desc = 'State Hunk' })
                    map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                        { desc = 'Reset Hunk' })
                    map('n', '<leader>gS', gs.stage_buffer, { desc = 'State Buffer' })
                    map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Undo State Hunk' })
                    map('n', '<leader>gR', gs.reset_buffer, { desc = 'Reset Buffer' })
                    map('n', '<leader>gp', gs.preview_hunk, { desc = 'Preview Hunk' })
                    map('n', '<leader>gb', function() gs.blame_line { full = true } end, { desc = 'Blame Line' })
                    map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle Current Line Blame' })
                    map('n', '<leader>gd', gs.diffthis, { desc = 'Diff this' })
                    map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = 'Diff this ~' })
                    map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle Deleted' })

                    -- Text object
                    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Git Signs Select Hunk' })
                end
            })
        end,
    },
    -- Git wrapper
    { "tpope/vim-fugitive",                       lazy = false },
    "f-person/git-blame.nvim",
    -- ---------------------------------------------------------
    --- COMPLETIONS SUPPORT
    --------------------------------------------------------

    -- Completion engine
    "hrsh7th/nvim-cmp",
    -- Using this fork for nvim-cmp for the ability to put
    -- the completions above the line to avoid conflicting with copilot
    -- {
    --     "llllvvuu/nvim-cmp",
    --     branch = "feat/above"
    -- },
    -- cmp source for nvim api
    "hrsh7th/cmp-nvim-lsp",
    -- cmp source for buffer words
    "hrsh7th/cmp-buffer",
    -- cmp source for filesystem paths
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    -- completions for signatures
    --  "hrsh7th/cmp-nvim-lsp-signature-help" ,
    "hrsh7th/cmp-nvim-lua",
    -- github copilot
    "zbirenbaum/copilot-cmp",
    "zbirenbaum/copilot.lua",
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
        },
    },
    -- "github/copilot.vim",
    "onsails/lspkind.nvim",
    --------------------------------------------------------
    --- LSP SUPPORT
    --------------------------------------------------------

    -- LSP configuration
    "folke/neoconf.nvim",
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "SmiteshP/nvim-navbuddy",
            dependencies = {
                "SmiteshP/nvim-navic",
                "MunifTanjim/nui.nvim"
            },
            opts = { lsp = { auto_attach = true } }
        }
    },
    -- provides the underlying debugger support
    "mfussenegger/nvim-dap",
    {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
            require("nvim-dap-virtual-text").setup()
        end
    },
    -- debugger ui
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
    },
    -- configures lsp and debugger for rust
    {
        'mrcjkb/rustaceanvim',
        version = '^4', -- Recommended
        lazy = false,
    },
    {
        "ray-x/go.nvim",
        lazy = false,
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    -- fork of null-ls
    "nvimtools/none-ls.nvim",
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    -- LSP support neovim development
    {
        "folke/neodev.nvim",
        config = function()
            require("neodev").setup({
                library = { plugins = { "nvim-dap-ui" }, types = true },
            })
        end
    },
    -- Line indentation
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },
    -- colors for lsp diagnostics
    { "folke/lsp-colors.nvim" },
    -- Java LSP support
    {
        'nvim-java/nvim-java',
        dependencies = {
            'nvim-java/lua-async-await',
            'nvim-java/nvim-java-refactor',
            'nvim-java/nvim-java-core',
            'nvim-java/nvim-java-test',
            'nvim-java/nvim-java-dap',
            'MunifTanjim/nui.nvim',
            'neovim/nvim-lspconfig',
            'mfussenegger/nvim-dap',
            {
                'williamboman/mason.nvim',
                opts = {
                    registries = {
                        'github:nvim-java/mason-registry',
                        'github:mason-org/mason-registry',
                    },
                },
            }
        },
    },
    {
        "scalameta/nvim-metals",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "mfussenegger/nvim-dap",
                config = function()
                    -- Debug settings if you're using nvim-dap
                    local dap = require("dap")

                    dap.configurations.scala = {
                        {
                            type = "scala",
                            request = "launch",
                            name = "RunOrTest",
                            metals = {
                                runType = "runOrTestFile",
                                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
                            },
                        },
                        {
                            type = "scala",
                            request = "launch",
                            name = "Test Target",
                            metals = {
                                runType = "testTarget",
                            },
                        },
                    }
                end
            },
        },
        ft = { "scala", "sbt" },
    },
    -- nushell support
    {
        "LhKipp/nvim-nu",
        build = ":TSInstall nu",
        lazy = false,
        -- ft = "nu",
        config = function()
            require 'nu'.setup {
                use_lsp_features = true, -- requires https://github.com/jose-elias-alvarez/null-ls.nvim
                -- lsp_feature: all_cmd_names is the source for the cmd name completion.
                -- It can be
                --  * a string, which is evaluated by nushell and the returned list is the source for completions (requires plenary.nvim)
                --  * a list, which is the direct source for completions (e.G. all_cmd_names = {"echo", "to csv", ...})
                --  * a function, returning a list of strings and the return value is used as the source for completions
                all_cmd_names = [[help commands | get name | str join "\n"]]
            }
        end,
    },
    -- json/yaml schema stores
    "b0o/SchemaStore.nvim",
    {
        "andythigpen/nvim-coverage",
        ft = "rust",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("coverage").setup()
        end,
    },
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        branch = "harpoon2",
        config = true,
    },
    -- {
    --     'alexghergh/nvim-tmux-navigation',
    --     lazy = false,
    --     config = function()
    --         require 'nvim-tmux-navigation'.setup {
    --             disable_when_zoomed = true, -- defaults to false
    --             keybindings = {
    --                 left = "<C-h>",
    --                 down = "<C-j>",
    --                 up = "<C-k>",
    --                 right = "<C-l>",
    --                 last_active = "<C-\\>",
    --                 next = "<C-Space>",
    --             }
    --         }
    --     end
    -- },
    {
        "https://git.sr.ht/~swaits/zellij-nav.nvim",
        lazy = true,
        event = "VeryLazy",
        keys = {
            { "<c-h>", "<cmd>ZellijNavigateLeft<cr>",  { silent = true, desc = "navigate left" } },
            { "<c-j>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "navigate down" } },
            { "<c-k>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "navigate up" } },
            { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
        },
        opts = {},
    },
    {
        "norcalli/nvim-colorizer.lua",
        lazy = false,
        config = function() require("colorizer").setup() end,
    },
    -- file manager
    {
        'stevearc/oil.nvim',
        opts = function()
            local detail = false;
            return {
                win_options = {
                    signcolumn = "yes:2",
                },
                view_options = {
                    show_hidden = true,
                },
                keymaps = {
                    -- The following two keymaps conflict with vim tmux navigation
                    -- so I disabled them
                    ["<C-h>"] = false,
                    ["<C-l>"] = false,
                    ["F5"] = "actions.refresh",
                    ["gi"] = {
                        desc = "Toggle file detail view",
                        callback = function()
                            detail = not detail
                            if detail then
                                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                            else
                                require("oil").set_columns({ "icon" })
                            end
                        end,
                    }
                }
            }
        end,
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "refractalize/oil-git-status.nvim",
        dependencies = {
            "stevearc/oil.nvim",
        },
        config = true,
    },
    -- Extra power search and replace
    {
        "tpope/vim-abolish",
        lazy = false,
    },
    -- using mason for installing packages that are broken in nix.
    -- Looking at you vscode-lldb.
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- General testing plugin
    {
        "klen/nvim-test",
        opts = {
            termOpts = {
                direction = "horizontal",
            },
        },
        config = true,
    },
    -- LSP status, etc
    {
        "j-hui/fidget.nvim",
        lazy = false,
        version = "1",
        config = true,
    },
    -- tab line
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                diagnostics = "nvim_lsp",
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = { 'close' },
                },
            }
        },
    },
    "jake-stewart/multicursor.nvim",
    {
        "gbprod/substitute.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    -- nvim v0.8.0
    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    }
})

return M
