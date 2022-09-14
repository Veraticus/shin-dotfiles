package.path = package.path .. ';' .. os.getenv( "HOME" ) .. '/.config/nvim/?.lua'

require('init')

local opt = vim.opt
local g = vim.g
local cmd = vim.cmd
opt.number = false
opt.signcolumn = 'no'
opt.scrollback = 100000
opt.laststatus = 0

cmd [[set nobackup]]
cmd [[set noswapfile]]
cmd [[set noundofile]]
--
-- Autocommands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
autocmd('VimEnter', {
  group = augroup('start_at_bottom', {clear = true}),
  command = 'normal G'
})
autocmd('TermEnter', {
  group = augroup('prevent_insert', {clear = true}),
  command = 'stopinsert'
})

local silent = { silent = true, noremap = true }
local map = vim.api.nvim_set_keymap

map('n', 'q', '<cmd>qa!<cr>', silent)
