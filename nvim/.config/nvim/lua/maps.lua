local utils = require('utils')
local map = utils.map

-- Esc in the terminal
map('t', '<Esc>', [[<C-\><C-n>]])

-- Window movement
map('n', '<c-h>', '<c-w>h')
map('n', '<c-j>', '<c-w>j')
map('n', '<c-k>', '<c-w>k')
map('n', '<c-l>', '<c-w>l')

-- No highlights!
map('n', '<leader>n', '<cmd>noh<cr>')

-- Reload the LSP
map('n', '<leader>l',
    [[<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<cr>]])
