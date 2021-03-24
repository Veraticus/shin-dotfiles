local utils = require('utils')
local opt = utils.opt
local autocmd = utils.autocmd
local map = utils.map

-- Quit, close buffers, etc.
map('n', '<C-c>', '<cmd>Sayonara<cr>', {silent = true, nowait = true})

-- Save buffer
map('n', '<leader>w', '<cmd>w<cr>', {silent = true})

-- Version control
map('n', '<leader>g', '<cmd>Gstatus<cr>', silent)

-- Esc in the terminal
map('t', '<Esc>', [[<C-\><C-n>]])

-- Window movement
map('n', '<c-h>', '<c-w>h')
map('n', '<c-j>', '<c-w>j')
map('n', '<c-k>', '<c-w>k')
map('n', '<c-l>', '<c-w>l')
