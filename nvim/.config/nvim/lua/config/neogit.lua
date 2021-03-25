local utils = require('utils')
local map = utils.map

map('n', '<leader>g', '<cmd>Neogit<cr>', {silent = true, nowait = true})
