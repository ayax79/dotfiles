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

    -- -- Start Screen
    {
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        config = function()
            require("dashboard").setup({
                theme = "hyper",
                change_to_vscs_root = true,
                config = {
                    week_header = {
                        enable = true,
                    },
                    project = {
                        enable = true,
                        limit = 8,
                        label = "Projects",
                        action = "Telescope find_files cwd=",
                    },
                    packages = { enable = true },
                },
            })
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

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
    --   Better Buffer (tabs) support
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local cfg = {
                options = {
                    separator_style = "thin",
                },
            }

            if vim.g.theme_name == "nord" then
                cfg.highlights = require("nord").bufferline.highlights({
                    italic = true,
                    bold = true,
                })
            end

            require("bufferline").setup(cfg)
        end,
    },
    -- Status line support
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
                    lualine_x = {
                        {
                            require("noice").api.status.command.get,
                            cond = require("noice").api.status.command.has,
                            color = { fg = "#D08770" },
                        },
                        {
                            require("noice").api.status.mode.get,
                            cond = require("noice").api.status.mode.has,
                            color = { fg = "#D08770" },
                        },
                        {
                            require("noice").api.status.search.get,
                            cond = require("noice").api.status.search.has,
                            color = { fg = "#D08770" },
                        }, "encoding", "fileformat", "filetype",
                    },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    -- lualine_x = { "location" },
                    lualine_x = {},
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
            require('lspsaga').setup({})
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons',     -- optional
        }
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
            local actions = require("telescope.actions")
            local open_with_trouble = require("trouble.sources.telescope").open

            -- Use this to add more results without clearing the trouble list
            local add_to_trouble = require("trouble.sources.telescope").add

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
                },
            })

            telescope.load_extension("ui-select")
            telescope.load_extension("noice")
        end,
    },
    -- bookmark support
    { "MattesGroeger/vim-bookmarks" },
    -- search bookmarks in telescope
    { "tom-anders/telescope-vim-bookmarks.nvim" },
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
    -- A simple statusline/winbar component that uses LSP to show your current code context. Named after the Indian satellite navigation system.
    {
        "SmiteshP/nvim-navic",
        dependencies = "neovim/nvim-lspconfig",
    },
    -- handy keybindings
    {
        "tpope/vim-unimpaired",
    },
    -- illuminates all instances that is selected
    { "RRethy/vim-illuminate" },

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
    { "tpope/vim-fugitive",   lazy = false },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "nvim-telescope/telescope.nvim", -- optional
            "sindrets/diffview.nvim",        -- optional
        },
        config = true
    },
    "f-person/git-blame.nvim",
    -- ---------------------------------------------------------
    --- COMPLETIONS SUPPORT
    --------------------------------------------------------

    -- Completion engine
    { "hrsh7th/nvim-cmp" },
    -- cmp source for nvim api
    { "hrsh7th/cmp-nvim-lsp" },
    -- cmp source for buffer words
    { "hrsh7th/cmp-buffer" },
    -- cmp source for filesystem paths
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    -- snippet support and completions
    { "hrsh7th/cmp-vsnip" },
    { "hrsh7th/vim-vsnip" },
    { "hrsh7th/vim-vsnip-integ" },
    -- completions for signatures
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "hrsh7th/cmp-nvim-lua" },
    -- github copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
    },
    -- cmp source for copilot
    {
        "zbirenbaum/copilot-cmp",
    },
    -- -- vscode like completion icons
    "onsails/lspkind.nvim",
    {
        "epwalsh/obsidian.nvim",
        lazy = true,
        event = {
            "BufReadPre " .. vim.fn.expand("~") .. "/src/disqo/jack.wright/disqo-vault/**.md",
        },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",

            -- Optional, for completion.
            "hrsh7th/nvim-cmp",

            -- Optional, for search and quick-switch functionality.
            "nvim-telescope/telescope.nvim",
            -- Optional, alternative to nvim-treesitter for syntax highlighting.
            "godlygeek/tabular",
            "preservim/vim-markdown",
        },
        opts = {
            dir = "~/src/disqo/jack.wright/disqo-vault/", -- no need to call 'vim.fn.expand' here
            mappings = {
                -- ["llk"] = require("obsidian.mapping").gf_passthrough(),
            },
            -- Optional, if you keep notes in a specific subdirectory of your vault.
            notes_subdir = "notes",

            -- Optional, set the log level for Obsidian. This is an integer corresponding to one of the log
            -- levels defined by "vim.log.levels.*" or nil, which is equivalent to DEBUG (1).
            log_level = vim.log.levels.DEBUG,

            daily_notes = {
                -- Optional, if you keep daily notes in a separate directory.
                folder = "notes/dailies",
                -- Optional, if you want to change the date format for daily notes.
                date_format = "%Y-%m-%d",
            },

            -- Optional, completion.
            completion = {
                -- If using nvim-cmp, otherwise set to false
                nvim_cmp = true,
                -- Trigger completion at 2 chars
                min_chars = 2,
            },

            -- Optional, customize how names/IDs for new notes are created.
            note_id_func = function(title)
                -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
                -- In this case a note with the title 'My new note' will given an ID that looks
                -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
                local suffix = ""
                if title ~= nil then
                    -- If title is given, transform it into valid file name.
                    suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                else
                    -- If title is nil, just add 4 random uppercase letters to the suffix.
                    for _ = 1, 4 do
                        suffix = suffix .. string.char(math.random(65, 90))
                    end
                end
                return tostring(os.time()) .. "-" .. suffix
            end,

            -- Optional, set to true if you don't want Obsidian to manage frontmatter.
            disable_frontmatter = false,

            -- Optional, alternatively you can customize the frontmatter data.
            note_frontmatter_func = function(note)
                -- This is equivalent to the default frontmatter function.
                local out = { id = note.id, aliases = note.aliases, tags = note.tags }
                -- `note.metadata` contains any manually added fields in the frontmatter.
                -- So here we just make sure those fields are kept in the frontmatter.
                if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
                    for k, v in pairs(note.metadata) do
                        out[k] = v
                    end
                end
                return out
            end,

            -- Optional, for templates (see below).
            -- templates = {
            --     subdir = "templates",
            --     date_format = "%Y-%m-%d-%a",
            --     time_format = "%H:%M",
            -- },
            --
            -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
            -- URL it will be ignored but you can customize this behavior here.
            follow_url_func = function(url)
                -- Open the URL in the default web browser.
                vim.fn.jobstart({ "^open", url }) -- Mac OS
                -- vim.fn.jobstart({"xdg-open", url})  -- linux
            end,

            -- Optional, set to true if you use the Obsidian Advanced URI plugin.
            -- https://github.com/Vinzent03/obsidian-advanced-uri
            use_advanced_uri = true,

            -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
            open_app_foreground = false,

            -- Optional, by default commands like `:ObsidianSearch` will attempt to use
            -- telescope.nvim, fzf-lua, and fzf.nvim (in that order), and use the
            -- first one they find. By setting this option to your preferred
            -- finder you can attempt it first. Note that if the specified finder
            -- is not installed, or if it the command does not support it, the
            -- remaining finders will be attempted in the original order.
            finder = "telescope.nvim",
        },
    },

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
    { "mfussenegger/nvim-dap" },
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
        opts = {
            cmp = {
                enabled = true,
            }
        },
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
        ft = { "scala", "sbt", "java" },
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
        "nvim-neotest/neotest",
        ft = "rust",
        lazy = false,
        dependencies = { "rouge8/neotest-rust" },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-rust") {
                        args = { "--no-capture" },
                        dap_adapter = "lldb",
                    }
                }
            })
        end
    },
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        branch = "harpoon2",
        config = true,
    },
    -- lazy.nvim
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
        lazy = false,
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true,         -- use a classic bottom cmdline for search
                    command_palette = true,       -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false,       -- add a border to hover docs and signature help
                },
            })
        end
    },
    {
        'alexghergh/nvim-tmux-navigation',
        lazy = false,
        config = function()
            require 'nvim-tmux-navigation'.setup {
                disable_when_zoomed = true, -- defaults to false
                keybindings = {
                    left = "<C-h>",
                    down = "<C-j>",
                    up = "<C-k>",
                    right = "<C-l>",
                    last_active = "<C-\\>",
                    next = "<C-Space>",
                }
            }
        end
    },
    {
        "norcalli/nvim-colorizer.lua",
        lazy = false,
        config = function() require("colorizer").setup() end,
    },
    {
        'stevearc/oil.nvim',
        opts = {
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                -- The following two keymaps conflict with vim tmux navigation
                -- so I disabled them
                ["<C-h>"] = false,
                ["<C-l>"] = false,
                ["F5"] = "actions.refresh",
            }
        },
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "tpope/vim-abolish",
        lazy = false,
    },
    -- using mason for installing packages that are broken in nix.
    -- Looking at you vscode-lldb.
    {
        "williamboman/mason.nvim",
        lazy = true,
        config = true,
    },
    {
        "folke/twilight.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
})

return M
