local utils = require('utils')
local map = utils.map

map('n', '<C-c>', '<cmd>Sayonara<cr>', {silent = true, nowait = true})
