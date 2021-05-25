local dracula = {}
-- LuaFormatter off
local colors = {
  gray       = '#2E2B3B',
  lightgray  = '#7970A9',
  orange     = '#FFCA80',
  purple     = '#9580FF',
  red        = '#FF9580',
  yellow     = '#FFFF80',
  green      = '#8AFF80',
  white      = '#F8F8F2',
  black      = '#0B0B0F',
}
-- LuaFormatter on

dracula.normal = {
    a = {bg = colors.purple, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.gray, fg = colors.white}
}

dracula.insert = {
    a = {bg = colors.green, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.gray, fg = colors.white}
}

dracula.visual = {
    a = {bg = colors.yellow, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.gray, fg = colors.white}
}

dracula.replace = {
    a = {bg = colors.red, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.gray, fg = colors.white}
}

dracula.command = {
    a = {bg = colors.orange, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.gray, fg = colors.white}
}

dracula.inactive = {
    a = {bg = colors.gray, fg = colors.white, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.gray, fg = colors.white}
}

require('lualine').setup {
    options = {theme = dracula},
    sections = {
        lualine_a = {{'mode', upper = true}},
        lualine_b = {{'branch', icon = ''}},
        lualine_c = {{'filename', file_status = true, path = 1}},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {
            {
                'diagnostics',
                sources = {'nvim_lsp'},
                {error = ' ', warn = ' ', info = ' '}
            }
        }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{'filename', file_status = true, path = 1}},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    }
}
