local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    ignore_install = {"lua"},
    sync_install = false,
    auto_install = true,
    highlight = {enable = true, additional_vim_regex_highlighting = true},
    indent = {enable = true},
    incremental_selection = {enable = true},
    autotag = {enable = true},
    rainbow = {enable = true},
    refactor = {highlight_definitions = {enable = true}},
    textsubjects = {
        enable = true,
        prev_selection = ',', -- (Optional) keymap to select the previous selection
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
        },
    },
}

