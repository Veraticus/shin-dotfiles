local lspconfig = require('lspconfig')
local coq = require "coq"
local lsp_status = require('lsp-status')
local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
require "lsp.formatting"
require "lsp.handlers"

configs.terraformlsp = {
    default_config = {
        cmd = {"terraform-lsp"},
        filetypes = {"terraform", "hcl"},
        root_dir = util.root_pattern(".terraform", ".git")
    },
    docs = {
        description = [[
https://github.com/juliosueiras/terraform-lsp
Terraform language server
Download a released binary from https://github.com/hashicorp/terraform-ls/releases.
]],
        default_config = {root_dir = [[root_pattern(".terraform", ".git")]]}
    }
}

vim.fn.sign_define("LspDiagnosticsSignError",
                   {text = "", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning",
                   {text = "", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation",
                   {text = "", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint",
                   {text = "", numhl = "LspDiagnosticsDefaultHint"})

local texlab_search_status = vim.tbl_add_reverse_lookup {
    Success = 0,
    Error = 1,
    Failure = 2,
    Unconfigured = 3
}

lsp_status.config {
    kind_labels = vim.g.completion_customize_lsp_label,
    select_symbol = function(cursor_pos, symbol)
        if symbol.valueRange then
            local value_range = {
                ['start'] = {
                    character = 0,
                    line = vim.fn.byte2line(symbol.valueRange[1])
                },
                ['end'] = {
                    character = 0,
                    line = vim.fn.byte2line(symbol.valueRange[2])
                }
            }

            return require('lsp-status/util').in_range(cursor_pos, value_range)
        end
    end,
    current_function = false
}

lsp_status.register_progress()

vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {spacing = 2, severity_limit = "Warning"},
        signs = true,
        update_in_insert = false,
        underline = true
    })

vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
        return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
end

local function make_on_attach(config)
    return function(client)
        if config.before then config.before(client) end

        lsp_status.on_attach(client)
        local opts = {noremap = true, silent = true}

        vim.api.nvim_buf_set_keymap(0, 'n', 'gh',
                                    [[<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>]],
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'gd',
                                    [[<cmd>lua require'lspsaga.provider'.preview_definition()<CR>]],
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'K',
                                    [[<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>]],
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'gi',
                                    '<cmd>lua vim.lsp.buf.implementation()<CR>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'gs',
                                    [[<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>]],
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'gTD',
                                    '<cmd>lua vim.lsp.buf.type_definition()<CR>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'gr',
                                    [[<cmd>lua require('lspsaga.rename').rename()<CR>]],
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'ca',
                                    [[<cmd>lua require('lspsaga.codeaction').code_action()<CR>]],
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'cd',
                                    [[<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()]],
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>E',
                                    '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', ']e',
                                    [[<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>]],
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', '[e',
                                    [[<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>]],
                                    opts)


        if client.resolved_capabilities.document_formatting or
            client.resolved_capabilities.document_range_formatting then
            vim.api.nvim_buf_set_keymap(0, 'n', '<leader>f',
                                        '<cmd>lua vim.lsp.buf.formatting()<cr>',
                                        opts)
            vim.cmd [[augroup Format]]
            vim.cmd [[autocmd! * <buffer>]]
            vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)]]
            vim.cmd [[augroup END]]
        end

        if config.after then config.after(client) end
    end
end

local prettier = require "efm/prettier"
local shellcheck = require "efm/shellcheck"
local terraform = require "efm/terraform"
local misspell = require "efm/misspell"
local servers = {
    bashls = {},
    cssls = {
        filetypes = {"css", "scss", "less", "sass"},
        root_dir = lspconfig.util.root_pattern("package.json", ".git")
    },
    dockerls = {},
    efm = {
        filetypes = {"lua", "js", "json", "yaml", "html", "md", "sh", "tf"},
        init_options = {documentFormatting = true},
        root_dir = vim.loop.cwd,
        settings = {
            languages = {
                ["="] = {misspell},
                javascriptreact = {prettier, eslint},
                json = {prettier},
                html = {prettier},
                markdown = {prettier},
                sh = {shellcheck},
                tf = {terraform}
            }
        }
    },
    gopls = {},
    html = {},
    rust_analyzer = {},
    sumneko_lua = {
        cmd = {'lua-language-server'},
        settings = {
            Lua = {
                diagnostics = {globals = {'vim'}},
                -- completion = {keywordSnippet = 'Disable'},
                runtime = {
                    version = 'LuaJIT',
                    path = vim.split(package.path, ';')
                },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                    }
                }
            }
        }
    },
    vimls = {},
    yamlls = {}
}

local snippet_capabilities = {
    textDocument = {completion = {completionItem = {snippetSupport = true}}}
}

local function deep_extend(policy, ...)
    local result = {}
    local function helper(policy, k, v1, v2)
        if type(v1) ~= 'table' or type(v2) ~= 'table' then
            if policy == 'error' then
                error('Key ' .. vim.inspect(k) ..
                          ' is already present with value ' .. vim.inspect(v1))
            elseif policy == 'force' then
                return v2
            else
                return v1
            end
        else
            return deep_extend(policy, v1, v2)
        end
    end

    for _, t in ipairs({...}) do
        for k, v in pairs(t) do
            if result[k] ~= nil then
                result[k] = helper(policy, k, result[k], v)
            else
                result[k] = v
            end
        end
    end

    return result
end

for server, config in pairs(servers) do
    config.on_attach = make_on_attach(config)
    config.capabilities = deep_extend('keep', config.capabilities or {},
                                      lsp_status.capabilities,
                                      snippet_capabilities)

    lspconfig[server].setup(coq.lsp_ensure_capabilities(config))
end
