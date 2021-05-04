require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true -- false will disable the whole extension
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false -- Whether the query persists across vim sessions
    },
    autotag = {enable = true},
    rainbow = {enable = true}
    -- refactor = {highlight_definitions = {enable = true}}
}

local parser_config = require"nvim-treesitter.parsers".get_parser_configs()
parser_config.terraform = {
    install_info = {
        url = "~/.dotfiles/parsers/tree-sitter-terraform/",
        files = {"src/parser.c"}
    },
    filetype = "terraform", -- if filetype does not agrees with parser name
    used_by = {"tf", "hcl"} -- additional filetypes that use this parser
}
