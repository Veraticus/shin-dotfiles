require('lualine').setup {
    options = {theme = 'tokyonight'},
    sections = {
        lualine_a = {{'mode', upper = true}},
        lualine_b = {{'branch', icon = ''}},
        lualine_c = {{'filename', file_status = true, full_path = true}},
        lualine_x = {
            'encoding', {'diagnostics', sources = {'nvim_lsp'}}, 'filetype'
        },
        lualine_y = {'progress'}
    }
}
