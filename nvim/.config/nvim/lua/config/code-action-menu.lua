local utils = require('utils')
local opt = utils.opt
local autocmd = utils.autocmd
local map = utils.map

map('n', '<leader>c', [[<cmd>CodeActionMenu<cr>]],
    {silent = true, nowait = true, noremap = true})


