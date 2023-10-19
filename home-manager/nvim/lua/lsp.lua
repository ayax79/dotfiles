M = {}

local home = os.getenv "HOME"
local nix_profile_bin = home .. "/.nix-profile/bin"

M.setup_codelens_refresh = function(client, bufnr)
    if client.supports_method("textDocument/codeLens") then
        -- refresh codelens on TextChanged and InsertLeave as well
        vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
        })
        -- trigger codelens refresh
        vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
    end
end

M.on_attach_common = function(client, bufnr)
    local navic = require("nvim-navic")
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

    local navic = require("nvim-navic")
    local capabilities = M.get_capabilities()
    local lspconfig = require("lspconfig")

    --------------------------------------------------------
    --- RUST CONFIGURATION
    --------------------------------------------------------

    -- HACK to add per project support for rust analyzer
    local get_project_rustanalyzer_settings = function()
        -- local rust_config_path = vim.fn.resolve(vim.fn.getcwd() .. '/./.rust-analyzer.json')
        local rust_config_path = vim.fn.getcwd() .. '/./.rust-analyzer.json'
        local handle = io.open(rust_config_path)
        if not handle then
            return {}
        end
        local out = handle:read("*a")
        handle:close()
        local config = vim.json.decode(out, {})
        if type(config) == "table" then
            return config
        end
        return {}
    end

    -- rust support
    local rt = require("rust-tools")
    rt.setup({
        tools = {
            runnables = {
                use_telescope = true,
            },
            inlay_hints = {
                -- auto = false,
                auto = true,
                show_parameter_hints = true,
                parameter_hints_prefix = "<-",
                other_hints_prefix = "=>",
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
            },
        },
        server = {
            on_attach = function(client, bufnr)
                navic.attach(client, bufnr)
                -- Hover actions
                vim.keymap.set(
                    "n",
                    "<C-space>",
                    rt.hover_actions.hover_actions,
                    { buffer = bufnr, desc = "Show hover actions" }
                )
                -- Code action groups
                vim.keymap.set(
                    "n",
                    "<Leader>la",
                    rt.code_action_group.code_action_group,
                    { buffer = bufnr, desc = "Code Action Group" }
                )
                -- Runnables
                vim.keymap.set("n", "<Leader>lr", rt.runnables.runnables, { buffer = bufnr, desc = "Runnables" })
                M.setup_codelens_refresh(client, bufnr)
            end,
            settings = {
                ['rust-analyzer'] = vim.tbl_deep_extend(
                    "force",
                    {
                        cargo = {
                            autoReload = true,
                        },
                    },
                    get_project_rustanalyzer_settings(),
                    {

                        procMacro = { enable = true },
                        diagnostics = { disabled = { "inactive-code" } },
                    }
                )
            },
        },
    })

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
        cmd = { nix_profile_bin .. "/vscode-json-languageserver", "--stdio" },
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
            null_ls.builtins.formatting.dprint,
            null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.completion.spell,
            null_ls.builtins.formatting.alejandra,
            null_ls.builtins.formatting.yq.with({
                extra_args = { '-y' },
            }),
        },
    })

    --------------------------------------------------------
    --- PYTHON CONFIGURATION
    --------------------------------------------------------
    lspconfig.pyright.setup {}

    --------------------------------------------------------
    --- NIL LS CONFIGURATION (NIX)
    --------------------------------------------------------
    require 'lspconfig'.nil_ls.setup {}
end
return M
