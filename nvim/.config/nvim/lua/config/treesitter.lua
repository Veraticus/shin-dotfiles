require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {enable = true, additional_vim_regex_highlighting = true},
    indent = {enable = true},
    incremental_selection = {enable = true},
    autotag = {enable = true},
    rainbow = {enable = true},
    refactor = {highlight_definitions = {enable = true}}
}
