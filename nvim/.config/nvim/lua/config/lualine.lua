require('lualine').setup {
    options = {theme = 'tokyonight'},
    sections = {
        lualine_a = {{'mode', upper = true}},
        lualine_b = {{'branch', icon = ''}},
        lualine_c = {{'filename', file_status = true, full_path = true}},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {
            {
                'diagnostics',
                sources = {'nvim_lsp'},
                {error = ' ', warn = ' ', info = ' '}
            }
        }
    }
}
