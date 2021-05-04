require'bufferline'.setup {
    options = {
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
        show_close_icon = false
    }
}

local utils = require('utils')
local map = utils.map

map('n', '[b', '<cmd>BufferLineCyclePrev<cr>', {silent = true, nowait = true})
map('n', ']b', '<cmd>BufferLineCycleNext<cr>', {silent = true, nowait = true})
