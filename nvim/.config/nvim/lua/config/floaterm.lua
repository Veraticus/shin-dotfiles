local utils = require('utils')
local opt = utils.opt
local autocmd = utils.autocmd
local map = utils.map

map('n', '<leader>t', [[<cmd>FloatermToggle<cr>]])

vim.g.floaterm_height = 0.95

