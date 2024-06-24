M = {}

-- local home = os.getenv "HOME"
-- local nix_profile_bin = home .. "/.nix-profile/bin"
local navic = require("nvim-navic")

M.setup_codelens_refresh = function(client, bufnr)
    local status_ok, codelens_supported = pcall(function()
        return client.supports_method("textDocument/codeLens")
    end)
    if not status_ok or not codelens_supported then
        return
    end
    local group = "lsp_code_lens_refresh"
    local cl_events = { "BufEnter", "InsertLeave" }
    local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
        group = group,
        buffer = bufnr,
        event = cl_events,
    })
    if ok and #cl_autocmds > 0 then
        return
    end
    local cb = function()
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_is_valid(bufnr) then
            vim.lsp.codelens.refresh({ bufnr = bufnr })
        end
    end
    vim.api.nvim_create_augroup(group, { clear = false })
    vim.api.nvim_create_autocmd(cl_events, {
        group = group,
        buffer = bufnr,
        callback = cb,
    })
end

M.on_attach_common = function(client, bufnr)
    local inlayhints = require("lsp-inlayhints")
    M.setup_codelens_refresh(client, bufnr)
    navic.attach(client, bufnr)
    inlayhints.on_attach(client, bufnr)
end

function M.get_capabilities()
    -- Add additional capabilities supported by nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    return capabilities
end

M.setup = function()
    require("neoconf").setup({
        -- override any of the default settings here
    })

    -- LSP Diagnostics Options Setup
    local sign = function(opts)
        vim.fn.sign_define(opts.name, {
            texthl = opts.name,
            text = opts.text,
            numhl = "",
        })
    end

    sign({ name = "DiagnosticSignError", text = "" })
    sign({ name = "DiagnosticSignWarn", text = "" })
    sign({ name = "DiagnosticSignHint", text = "" })
    sign({ name = "DiagnosticSignInfo", text = "" })

    vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = true,
        underline = true,
        severity_sort = false,
        float = {
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })

    --Set completeopt to have a better completion experience
    -- :help completeopt
    -- menuone: popup even when there's only one match
    -- noinsert: Do not insert text until a selection is made
    -- noselect: Do not select, force to select one from the menu
    -- shortness: avoid showing extra messages when using completion
    -- updatetime: set updatetime for CursorHold
    vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
    vim.opt.shortmess = vim.opt.shortmess + { c = true }
    vim.api.nvim_set_option_value("updatetime", 300, { scope = 'global' })

    -- Fixed column for diagnostics to appear
    -- Show autodiagnostic popup on cursor hover_range
    -- Goto previous / next diagnostic warning / error
    -- Show inlay_hints more frequently
    vim.cmd([[
    set signcolumn=yes
    autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

    require("lsp-colors").setup()

    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    dap.adapters.lldb = {
        type = "executable",
        command = "/opt/homebrew/llvm/bin/lldb-vscode",
        name = "lldb",
    }

    vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end

    local capabilities = M.get_capabilities()
    local lspconfig = require("lspconfig")

    --------------------------------------------------------
    --- RUST CONFIGURATION
    --------------------------------------------------------

    vim.g.rustaceanvim = function()
        -- Update this path
        local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
        local codelldb_path = extension_path .. 'adapter/codelldb'
        local liblldb_path = extension_path .. 'lldb/lib/liblldb'
        local this_os = vim.uv.os_uname().sysname;

        -- The path is different on Windows
        if this_os:find "Windows" then
            codelldb_path = extension_path .. "adapter\\codelldb.exe"
            liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
        else
            -- The liblldb extension is .so for Linux and .dylib for MacOS
            liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
        end
        local cfg = require('rustaceanvim.config')
        return {
            -- Plugin configuration
            tools = {
                runnables = {
                    use_telescope = true,
                },
                float_win_config = {
                    border = {
                        { '╭', 'FloatBorder' },
                        { '─', 'FloatBorder' },
                        { '╮', 'FloatBorder' },
                        { '│', 'FloatBorder' },
                        { '╯', 'FloatBorder' },
                        { '─', 'FloatBorder' },
                        { '╰', 'FloatBorder' },
                        { '│', 'FloatBorder' },
                    }
                },
            },
            -- LSP configuration
            server = {
                on_attach = function(client, bufnr)
                    M.on_attach_common(client, bufnr)
                    -- Hover actions
                    vim.keymap.set(
                        "n",
                        "<C-space>",
                        function() vim.cmd.RustLsp { 'hover', 'actions' } end,
                        { buffer = bufnr, desc = "Show hover actions" }
                    )
                    -- Code action groups
                    vim.keymap.set(
                        "n",
                        "<Leader>la",
                        function() vim.cmd.RustLsp('codeAction') end,
                        { buffer = bufnr, desc = "Code Action Group" }
                    )
                    -- Runnables

                    vim.keymap.set("n", "<Leader>lr", function() vim.cmd.RustLsp { 'runnables' } end,
                        { buffer = bufnr, desc = "Runnables" })
                    vim.keymap.set("n", "<Leader>lR", function() vim.cmd.RustLsp { 'runnables', 'last' } end,
                        { buffer = bufnr, desc = "Run Last" })

                    vim.keymap.set("n", "<Leader>ldr", function() vim.cmd.RustLsp { 'debuggables' } end,
                        { buffer = bufnr, desc = "Debuggables" })
                    vim.keymap.set("n", "<Leader>ldR", function() vim.cmd.RustLsp { 'debuggables', 'last' } end,
                        { buffer = bufnr, desc = "Debug Last" })

                    M.setup_codelens_refresh(client, bufnr)
                end,
                -- rust-analyzer language server configuration
                settings = {
                    ['rust-analyzer'] = {
                        check = {
                            features = "all",
                        },
                        cargo = {
                            autoReload = true,
                            features = "all",
                        },
                        procMacro = { enable = true },
                        diagnostics = { disabled = { "inactive-code" } },

                    },
                },
                -- ['rust-analyzer'] = vim.tbl_deep_extend(
                --     "force",
                --     {
                --         cargo = {
                --             autoReload = true,
                --         },
                --     },
                --     get_project_rustanalyzer_settings(),
                --     {
                --
                --         procMacro = { enable = true },
                --         diagnostics = { disabled = { "inactive-code" } },
                --     }
                -- )
                -- ,
            },
            -- DAP configuration
            dap = {
                adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
            },
        }
    end


    --------------------------------------------------------
    --- LUA configuration
    --------------------------------------------------------

    -- neodev should be called before lsp config
    require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
    })

    lspconfig.lua_ls.setup({
        on_attach = M.on_attach_common,
        capabilities = capabilities,
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace",
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
            },
        },
    })

    --------------------------------------------------------
    --- YAML configuration
    --------------------------------------------------------

    lspconfig.yamlls.setup {
        on_attach = M.on_attach_common,
        capabilities = capabilities,
        settings = {
            yaml = {
                hover = true,
                completion = true,
                schemaStore = {
                    -- You must disable built-in schemaStore support if you want to use
                    -- this plugin and its advanced options like `ignore`.
                    enable = false,
                    -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                    url = "",
                },
                schemas = require('schemastore').yaml.schemas(),
                customTags = {
                    -- SAM / Cloudformation
                    "!fn",
                    "!And",
                    "!If",
                    "!Not",
                    "!Equals",
                    "!Or",
                    "!FindInMap sequence",
                    "!Base64",
                    "!Cidr",
                    "!Ref",
                    "!Ref Scalar",
                    "!Sub",
                    "!GetAtt",
                    "!GetAZs",
                    "!ImportValue",
                    "!Select",
                    "!Split",
                    "!Join sequence",
                    -- gitlab ci
                    "!reference sequence",
                },
            },
        },
    }

    --------------------------------------------------------
    --- JSON LS configuration
    --------------------------------------------------------

    lspconfig.jsonls.setup {
        on_attach = M.on_attach_common,
        settings = {
            json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
            },
        },
    }

    --------------------------------------------------------
    --- NONE-LS configuration
    --------------------------------------------------------

    local null_ls = require("null-ls")

    null_ls.setup({
        sources = {
            -- null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.completion.spell,
            null_ls.builtins.formatting.alejandra,
            -- null_ls.builtins.formatting.yq.with({
            --     extra_args = { '-y' },
            -- }),
        },
    })

    --------------------------------------------------------
    --- PYTHON CONFIGURATION
    --------------------------------------------------------
    lspconfig.pyright.setup {}

    --------------------------------------------------------
    --- NIL LS CONFIGURATION (NIX)
    --------------------------------------------------------
    lspconfig.nil_ls.setup {
        settings = {
            ['nil'] = {
                autoArchive = true,
            },
        },
    }

    --------------------------------------------------------
    --- NUSHELL CONFIGURATION
    --------------------------------------------------------
    -- require 'lspconfig'.nushell.setup {}

    --------------------------------------------------------
    --- JAVA CONFIGURATION
    --------------------------------------------------------
    require('java').setup()
    require('lspconfig').jdtls.setup({})

    --------------------------------------------------------
    --- GO LANG CONFIGURATION
    --------------------------------------------------------
    lspconfig.gopls.setup({
        on_attach = M.on_attach_common,
    })
end
return M
