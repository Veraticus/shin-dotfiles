-- Based on: https://github.com/wren/dotfiles/blob/main/config/nvim/lua/plugins/galaxyline.lua
--
local gl = require('galaxyline')
local gls = gl.section
local fileinfo = require('galaxyline.provider_fileinfo')
local icons = require("nvim-nonicons")
gl.short_line_list = {'defx', 'LuaTree', 'vista'}

local colors = {
    bg = '#282a36',
    line_bg = '#44475a',
    fg = '#f8f8f2',
    comment = '#6272a4',

    yellow = '#f1fa8c',
    cyan = '#8be9fd',
    green = '#50fa7b',
    orange = '#ffb86c',
    purple = '#bd93f9',
    red = '#ff5555',
    pink = '#ff79c6'
}

local function buffer_not_empty()
    if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then return true end
    return false
end

local function filename_with_color()
    local is_help = vim.bo.filetype == 'help'
    local modified = vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(),
                                                 'modified')
    local fg = colors.fg
    local bg = colors.bg
    if modified then fg = colors.orange end
    vim.api.nvim_command('hi GalaxyFileName guifg=' .. fg .. ' guibg=' .. bg)
    local filename = vim.fn.expand('%:f')
    if is_help then filename = 'HELP - ' .. vim.fn.expand('%:t:r') end
    filename = ' ' .. filename
    return filename
end

local function inactive_filename_with_color()
    local is_help = vim.bo.filetype == 'help'
    local modified = vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(),
                                                 'modified')
    local fg = colors.cyan
    local bg = colors.line_bg
    if modified then fg = colors.orange end
    vim.api.nvim_command(
        'hi GalaxyInactiveFileName guifg=' .. fg .. ' guibg=' .. bg)
    local filename = vim.fn.expand('%:f')
    if is_help then filename = 'HELP - ' .. vim.fn.expand('%:t:r') end
    filename = ' ' .. filename .. ' '
    return filename
end

local mode_info = {
    n = {name = '  n  ', color = colors.comment},
    i = {name = '  i  ', color = colors.purple},
    v = {name = '  v  ', color = colors.pink},
    [''] = {color = colors.pink, name = ' vbw '},
    V = {color = colors.magenta, name = ' vb  '},
    c = {color = colors.purple, name = '  c  '},
    no = {color = colors.pink, name = ' no  '},
    s = {color = colors.orange, name = '  s  '},
    s = {color = colors.orange, name = '  s  '},
    [''] = {color = colors.orange, name = ' ^S  '},
    ic = {color = colors.yellow, name = ' ic  '},
    R = {color = colors.purple, name = '  R  '},
    Rv = {color = colors.purple, name = ' Rv  '},
    cv = {color = colors.red, name = ' cv  '},
    ce = {color = colors.red, name = ' ce  '},
    r = {color = colors.cyan, name = ' r  '},
    rm = {color = colors.cyan, name = ' rm  '},
    ['r?'] = {color = colors.cyan, name = ' r?  '},
    ['!'] = {color = colors.red, name = ' !  '},
    t = {color = colors.red, name = ' t  '}
}

local function update_mode_color()
    -- auto change color according the vim mode
    local modes = {
        "GalaxyViMode", "GalaxyPercent", "GalaxyLineColumn",
        "LineColumnSeparator", "EndSpaceSeparator"
    }
    for _, highlightGroup in ipairs(modes) do
        vim.api.nvim_command(
            'hi ' .. highlightGroup .. ' guifg=' .. colors.fg .. ' guibg=' ..
                mode_info[vim.fn.mode()].color)
    end
    vim.api.nvim_command('hi ViModeSeparator guifg=' ..
                             mode_info[vim.fn.mode()].color .. ' guibg=' ..
                             colors.line_bg)
    vim.api.nvim_command('hi PercentSeparator guifg=' ..
                             mode_info[vim.fn.mode()].color .. ' guibg=' ..
                             colors.bg)
end

local function checkwidth()
    local squeeze_width = vim.fn.winwidth(0) / 2
    if squeeze_width > 40 then return true end
    return false
end

local function buffer_is_modifiable() return vim.bo.modifiable end

local function buffer_is_not_modifiable() return not buffer_is_modifiable() end

---------------
-- Left side --
---------------
gls.left = {
    {
        ViMode = {
            icon = ' ',
            condition = buffer_is_modifiable,
            provider = function()
                update_mode_color()
                return ' ' .. mode_info[vim.fn.mode()].name .. ' '
            end,
            separator = ''
        }
    }, {
        Space1 = {
            provider = function() return ' ' end,
            separator = '',
            condition = buffer_not_empty,
            highlight = {colors.line_bg, colors.line_bg},
            separator_highlight = {colors.line_bg, colors.bg}
        }
    }, {
        Space2 = {
            provider = function() return ' ' end,
            condition = buffer_not_empty,
            highlight = {colors.bg, colors.bg}
        }
    }, {
        FileIcon = {
            provider = 'FileIcon',
            condition = buffer_not_empty,
            highlight = {fileinfo.get_file_icon_color, colors.bg}
        }
    }, {
        FileName = {
            provider = filename_with_color,
            condition = buffer_not_empty,
            highlight = {fileinfo.get_file_icon_color, colors.bg},
            separator = '',
            separator_highlight = {colors.bg, colors.line_bg}
        }
    }, {
        DiagnosticError = {
            separator = ' |  ',
            separator_highlight = {colors.line_bg, colors.line_bg},
            provider = 'DiagnosticError',
            icon = '  ',
            highlight = {colors.red, colors.line_bg}
        }
    }, {
        DiagnosticWarn = {
            provider = 'DiagnosticWarn',
            icon = '  ',
            highlight = {colors.yellow, colors.line_bg}
        }
    }, {
        Space3 = {
            provider = function() return ' ' end,
            highlight = {colors.line_bg, colors.line_bg}
        }
    }
}

----------------
-- Right side --
----------------

gls.right = {
    {
        GitBranch = {
            provider = "GitBranch",
            icon = "  " .. icons.get("git-branch") .. "  ",
            condition = require("galaxyline.condition").check_git_workspace,
            highlight = {colors.fg, colors.bg},
            separator = '',
            separator_highlight = {colors.bg, colors.line_bg}
        }
    }, {
        Percent = {
            provider = 'LinePercent',
            condition = buffer_is_modifiable,
            highlight = {colors.fg, colors.bg},
            separator = ' '
        }
    }, {
        LineColumn = {
            provider = 'LineColumn',
            condition = buffer_is_modifiable,
            separator = '☰ ',
            separator_highlight = {colors.blue, colors.line_bg},
            highlight = {colors.fg, colors.line_bg, 'bold'}
        }
    }, {
        EndSpace = {
            separator = ' ',
            condition = buffer_is_modifiable,
            provider = function() return '' end,
            highlight = {colors.fg, colors.line_bg, 'bold'}
        }
    }
}

----------------
-- Short line --
----------------

gls.short_line_left = {
    {
        InactiveMode = {
            icon = ' ',
            condition = buffer_is_modifiable,
            provider = function() return '   x   ' end,
            highlight = {colors.comment, colors.bg}
        }
    }, {
        InactiveSpace1 = {
            provider = function() return ' ' end,
            separator = '',
            condition = buffer_is_modifiable,
            highlight = {colors.comment, colors.bg},
            separator_highlight = {colors.bg, colors.line_bg}
        }
    }, {
        InactiveSpace2 = {
            provider = function() return '  ' end,
            condition = buffer_not_empty,
            highlight = {colors.line_bg, colors.line_bg}
        }
    }, {
        InactiveFileIcon = {
            provider = 'FileIcon',
            condition = buffer_not_empty,
            highlight = {fileinfo.get_file_icon_color, colors.line_bg}
        }
    }, {
        InactiveFileName = {
            provider = inactive_filename_with_color,
            condition = buffer_not_empty,
            highlight = {fileinfo.get_file_icon_color, colors.line_bg}
        }
    }, {
        Space5 = {
            provider = function() return ' ' end,
            highlight = {colors.comment, colors.line_bg}
        }
    }
}

gls.short_line_right = {
    {
        EndSpace2 = {
            provider = function() return '' end,
            highlight = {colors.line_bg, colors.bg}
        }
    }
}
