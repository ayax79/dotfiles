local debug = function(msg)
    -- print(msg)
end

local debug_file_status = function(path)
    debug("JDTLS: File: " .. path .. " exists: " .. (vim.fn.filereadable(path) and "true" or "false"))
end

debug("Starting JDTLS")

-- Determine OS
local home = os.getenv "HOME"
if vim.fn.has "mac" == 1 then
    WORKSPACE_PATH = home .. "/workspace/"
    CONFIG = "mac"
elseif vim.fn.has "unix" == 1 then
    WORKSPACE_PATH = home .. "/workspace/"
    CONFIG = "linux"
else
    debug "JDTLS: Unsupported operating system"
end

local jabba_jdk_dir = home .. '/.jabba/jdk/'
local jdk8_dir = jabba_jdk_dir .. 'amazon-corretto@8/Contents/Home'
local jdk11_dir = jabba_jdk_dir .. 'amazon-corretto@11.0/Contents/Home'
local jdk17_dir = jabba_jdk_dir .. 'amazon-corretto@17.0/Contents/Home'

local lsp = require('lsp')
local on_attach = function(client, bufnr)
    lsp.on_attach_common(client, bufnr)
    -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
    -- you make during a debug session immediately.
    -- Remove the option if you do not want that.
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls.setup").add_commands()
    require("jdtls.dap").setup_dap_main_class_configs()
    vim.lsp.buf.inlay_hint(bufnr, true)
end

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.cmdheight = 2 -- more space in the neovim command line for displaying messages

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
    return
end
capabilities.textDocument.completion.completionItem.snippetSupport = false
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

local status, jdtls = pcall(require, "jdtls")
if not status then
    return
end

local mason_dir = vim.fn.stdpath("data") .. "/mason"
debug_file_status(mason_dir)
local jdtls_dir = mason_dir .. "/share/jdtls"
debug_file_status(jdtls_dir)
local cfg_dir = home .. "/.config/nvim"
debug_file_status(cfg_dir)

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
    debug("Could not determine jdtls root")
    return
end
debug_file_status(root_dir)

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = WORKSPACE_PATH .. project_name
debug_file_status(workspace_dir)

-- DAP jars
local bundles = {}
vim.list_extend(bundles, vim.split(vim.fn.glob(cfg_dir .. "/vscode-java-test/server/*.jar"), "\n"))
vim.list_extend(
    bundles,
    vim.split(
        vim.fn.glob(
            cfg_dir .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
        ),
        "\n"
    )
)

local jdtls_java = jdk17_dir .. '/bin/java'
debug_file_status(jdtls_java)

local launcher = jdtls_dir .. "/plugins/org.eclipse.equinox.launcher.jar"
debug_file_status(launcher)

local lombok = jdtls_dir .. "/lombok.jar"
debug_file_status(lombok)

local config_dir = jdtls_dir .. "/config"
debug_file_status(config_dir)

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {

        -- 💀
        jdtls_java,
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. lombok,
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",

        -- 💀
        "-jar",
        launcher,
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
        -- Must point to the                                                     Change this to
        -- eclipse.jdt.ls installation                                           the actual version

        -- 💀
        "-configuration",
        config_dir,
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
        -- Must point to the                      Change to one of `linux`, `win` or `mac`
        -- eclipse.jdt.ls installation            Depending on your system.

        -- 💀
        -- See `data directory configuration` section in the README
        "-data",
        workspace_dir,
    },

    on_attach = on_attach,
    capabilities = capabilities,

    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = root_dir,

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- or https://github.com/redhat-developer/vscode-java#supported-vs-code-settings
    -- for a list of options
    settings = {
        java = {
            -- jdt = {
            --   ls = {
            --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
            --   }
            -- },
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                -- Valid entries
                -- https://github.com/redhat-developer/vscode-java/blob/c0e0a6376809e6c1d5f60bc5a2bfd07452e9a6db/package.json
                runtimes = {
                    {
                        name = 'JavaSE-1.8',
                        path = jdk8_dir
                    },
                    {
                        name = 'JavaSE-11',
                        path = jdk11_dir
                    },
                    {
                        name = 'JavaSE-17',
                        path = jdk17_dir,
                        default = true,
                    },
                }
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all", -- literals, all, none
                },
            },
            format = {
                enabled = false,
                -- settings = {
                --   profile = "asdf"
                -- }
            },
        },
        signatureHelp = { enabled = true },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
        },
        contentProvider = { preferred = "fernflower" },
        extendedClientCapabilities = extendedClientCapabilities,
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
    },
    flags = {
        allow_incremental_sync = true,
    },
    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
        bundles = bundles,
    },
}


-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
local ok = pcall(jdtls.start_or_attach, config)
if not ok then
    vim.notify("Failed to start or attach jdtls", vim.log.levels.ERROR)
    return
end

-- require('jdtls').setup_dap()

vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
vim.cmd "command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()"
-- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"
-- vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local opts = {
    mode = "n",     -- NORMAL mode
    prefix = "<leader>",
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true,  -- use `nowait` when creating keymaps
}

local vopts = {
    mode = "v",     -- VISUAL mode
    prefix = "<leader>",
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true,  -- use `nowait` when creating keymaps
}

local mappings = {
    L = {
        name = "Java",
        o = { require('jdtls').organize_imports, "Organize Imports" },
        v = { require('jdtls').extract_variable, "Extract Variable" },
        c = { require('jdtls').extract_constant, "Extract Constant" },
        t = { require('jdtls').test_nearest_method, "Test Method" },
        T = { require('jdtls').test_class, "Test Class" },
        u = { "<Cmd>JdtUpdateConfig<CR>", "Update Config" },
    },
}

local vmappings = {
    L = {
        name = "Java",
        v = { function() require('jdtls').extract_variable(true) end, "Extract Variable" },
        c = { function() require('jdtls').extract_constant(true) end, "Extract Constant" },
        m = { function() require('jdtls').extract_method(true) end, "Extract Method" },
    },
}

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)

-- debugging
-- git clone git@github.com:microsoft/java-debug.git
