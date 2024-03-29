local g = vim.g
local cmd = vim.cmd

-- Commands
local create_cmd = vim.api.nvim_create_user_command
create_cmd('PackerInstall', function()
  cmd [[packadd packer.nvim]]
  require('plugins').install()
end, {})
create_cmd('PackerUpdate', function()
  cmd [[packadd packer.nvim]]
  require('plugins').update()
end, {})
create_cmd('PackerSync', function()
  cmd [[packadd packer.nvim]]
  require('plugins').sync()
end, {})
create_cmd('PackerClean', function()
  cmd [[packadd packer.nvim]]
  require('plugins').clean()
end, {})
create_cmd('PackerCompile', function()
  cmd [[packadd packer.nvim]]
  require('plugins').compile()
end, {})

require 'impatient'
vim.notify = require 'notify'

-- Leader/local leader
g.mapleader = [[ ]]
g.maplocalleader = [[,]]

-- Skip some remote provider loading
g.loaded_python3_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Disable some built-in plugins we don't want
local disabled_built_ins = {
  'gzip',
  'man',
  'matchit',
  'matchparen',
  'shada_plugin',
  'tarPlugin',
  'tar',
  'zipPlugin',
  'zip',
  'netrwPlugin',
}

for i = 1, 10 do
  g['loaded_' .. disabled_built_ins[i]] = 1
end

-- Settings
local opt = vim.opt
opt.textwidth = 0
opt.scrolloff = 4
opt.wildignore = { '*.o', '*~', '*.pyc' }
opt.wildmode = 'longest,full'
opt.wildoptions = 'pum'
opt.whichwrap:append '<,>,h,l'
opt.inccommand = 'nosplit'
opt.lazyredraw = true
opt.showmatch = true
opt.ignorecase = true
opt.smartcase = true
opt.tabstop = 2
opt.softtabstop = 0
opt.expandtab = true
opt.shiftwidth = 2
opt.number = true
opt.backspace = 'indent,eol,start'
opt.smartindent = true
opt.laststatus = 3
opt.showmode = false
opt.shada = [['20,<50,s10,h,/100]]
opt.hidden = true
opt.shortmess:append 'c'
opt.joinspaces = false
opt.guicursor = [[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]]
opt.updatetime = 100
opt.conceallevel = 2
opt.concealcursor = 'nc'
opt.previewheight = 5
opt.undofile = true
opt.synmaxcol = 500
opt.display = 'msgsep'
opt.cursorline = true
opt.modeline = false
opt.mouse = 'nivh'
opt.signcolumn = 'yes:1'
opt.ruler = true
opt.clipboard = 'unnamedplus'

cmd [[set nobackup]]
cmd [[set noswapfile]]
cmd [[set noundofile]]

-- Colorscheme
opt.termguicolors = true

--[[ cmd [[colorscheme dracula_pro]]

-- Autocommands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
autocmd('VimEnter', {
  group = augroup('start_screen', { clear = true }),
  once = true,
  callback = function()
    require('start').start()
  end,
})
local misc_aucmds = augroup('misc_aucmds', { clear = true })
autocmd('BufWinEnter', { group = misc_aucmds, command = 'checktime' })
autocmd('TextYankPost', {
  group = misc_aucmds,
  callback = function()
    vim.highlight.on_yank()
  end,
})
autocmd('FileType', { group = misc_aucmds, pattern = 'qf', command = 'set nobuflisted' })

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
})

-- Keybindings
local silent = { silent = true, noremap = true }

-- Quit, close buffers, etc.
local map = vim.api.nvim_set_keymap
map('n', '<leader>q', '<cmd>qa<cr>', silent)
map('n', '<leader>x', '<cmd>x!<cr>', silent)
map('n', '<leader>d', '<cmd>Sayonara<cr>', { silent = true, nowait = true, noremap = true })

-- Save buffer
map('i', '<c-s>', '<esc><cmd>w<cr>a', silent)
map('n', '<leader>w', '<cmd>w<cr>', silent)

-- Version control
map('n', 'gs', '<cmd>Neogit<cr>', silent)

-- Esc in the terminal
map('t', 'jj', [[<C-\><C-n>]], silent)

-- Window movement
map('n', '<c-h>', '<c-w>h', silent)
map('n', '<c-j>', '<c-w>j', silent)
map('n', '<c-k>', '<c-w>k', silent)
map('n', '<c-l>', '<c-w>l', silent)

-- Tab movement
map('n', '<c-Left>', '<cmd>tabpre<cr>', silent)
map('n', '<c-Right>', '<cmd>tabnext<cr>', silent)

-- No highlights!
map('n', '<leader>n', '<cmd>noh<cr>', silent)
