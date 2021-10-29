local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
    install_info = {
        url = "https://github.com/vhyrro/tree-sitter-norg",
        files = { "src/parser.c" },
        branch = "main"
    },
}

require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {enable = true, additional_vim_regex_highlighting = true},
    indent = {enable = true},
    incremental_selection = {enable = true},
    autotag = {enable = true},
    rainbow = {enable = true},
    refactor = {highlight_definitions = {enable = true}},
    textsubjects = {
        enable = true,
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-big',
        }
    }
}

