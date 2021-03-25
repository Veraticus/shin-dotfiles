local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')
local lspkind = require('lspkind')

local sign_define = vim.fn.sign_define
sign_define('LspDiagnosticsSignError', {text = '', numhl = 'RedSign'})
sign_define('LspDiagnosticsSignWarning', {text = '', numhl = 'YellowSign'})
sign_define('LspDiagnosticsSignInformation', {text = '', numhl = 'WhiteSign'})
sign_define('LspDiagnosticsSignHint', {text = '', numhl = 'BlueSign'})

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
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true
    })

local function make_on_attach(config)
    return function(client)
        if config.before then config.before(client) end

        lsp_status.on_attach(client)
        local opts = {noremap = true, silent = true}
        vim.api.nvim_buf_set_keymap(0, 'n', 'gD',
                                    '<cmd>lua vim.lsp.buf.declaration()<CR>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'gd',
                                    '<cmd>lua vim.lsp.buf.definition()<CR>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'K',
                                    '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'gi',
                                    '<cmd>lua vim.lsp.buf.implementation()<CR>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', '<c-s>',
                                    '<cmd>lua vim.lsp.buf.signature_help()<CR>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'gTD',
                                    '<cmd>lua vim.lsp.buf.type_definition()<CR>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rn',
                                    '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'gr',
                                    '<cmd>lua vim.lsp.buf.references()<CR>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', 'gA',
                                    '<cmd>lua vim.lsp.buf.code_action()<CR>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>e',
                                    '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>E',
                                    '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', ']e',
                                    '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>',
                                    opts)
        vim.api.nvim_buf_set_keymap(0, 'n', '[e',
                                    '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>',
                                    opts)

        if client.resolved_capabilities.document_formatting or
            client.resolved_capabilities.document_range_formatting then
            vim.api.nvim_buf_set_keymap(0, 'n', '<leader>f',
                                        '<cmd>lua vim.lsp.buf.formatting()<cr>',
                                        opts)
            vim.cmd [[augroup Format]]
            vim.cmd [[autocmd! * <buffer>]]
            vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
            vim.cmd [[augroup END]]
        end

        if client.resolved_capabilities.document_highlight == true then
            vim.api.nvim_command('augroup lsp_aucmds')
            vim.api.nvim_command(
                'au CursorHold <buffer> lua vim.lsp.buf.document_highlight()')
            vim.api.nvim_command(
                'au CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()')
            vim.api.nvim_command(
                'au CursorMoved <buffer> lua vim.lsp.buf.clear_references()')
            vim.api.nvim_command('augroup END')
        end

        if config.after then config.after(client) end
    end
end

local servers = {
    bashls = {},
    cssls = {
        filetypes = {"css", "scss", "less", "sass"},
        root_dir = lspconfig.util.root_pattern("package.json", ".git")
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
    terraformls = {},
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

    lspconfig[server].setup(config)
end