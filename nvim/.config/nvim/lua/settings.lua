local g = vim.g
local cmd = vim.cmd
local o, wo, bo = vim.o, vim.wo, vim.bo
local utils = require('utils')
local opt = utils.opt
local autocmd = utils.autocmd
local map = utils.map

-- Leader/local leader
g.mapleader = [[ ]]
g.maplocalleader = [[,]]

-- Skip some remote provider loading
g.loaded_python_provider = 0
g.python_host_prog = '/usr/bin/python2'
g.python3_host_prog = '/usr/local/bin/python3'
g.node_host_prog = '/usr/local/bin/node'

-- Disable some built-in plugins we don't want
local disabled_built_ins = {
  'gzip', 'man', 'matchit', 'matchparen', 'shada_plugin', 'tarPlugin', 'tar', 'zipPlugin', 'zip',
  'netrwPlugin'
}
for i = 1, 10 do g['loaded_' .. disabled_built_ins[i]] = 1 end

-- Settings
local buffer = {o, bo}
local window = {o, wo}
opt('textwidth', 100, buffer)
opt('scrolloff', 7)
opt('wildignore', '*.o,*~,*.pyc')
opt('wildmode', 'longest,full')
opt('whichwrap', vim.o.whichwrap .. '<,>,h,l')
opt('inccommand', 'nosplit')
opt('lazyredraw', true)
opt('showmatch', true)
opt('ignorecase', true)
opt('smartcase', true)
opt('tabstop', 2, buffer)
opt('softtabstop', 0, buffer)
opt('expandtab', true, buffer)
opt('shiftwidth', 4, buffer)
opt('number', true, window)
opt('smartindent', true, buffer)
opt('laststatus', 2)
opt('shada', [['20,<50,s10,h,/100]])
opt('hidden', true)
opt('shortmess', o.shortmess .. 'c')
opt('completeopt', 'menuone,noselect')
opt('joinspaces', false)
opt('guicursor', [[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]])
opt('updatetime', 500)
opt('conceallevel', 2, window)
opt('concealcursor', 'nc', window)
opt('previewheight', 5)
opt('undofile', true, buffer)
opt('synmaxcol', 500, buffer)
opt('display', 'msgsep')
opt('cursorline', true, window)
opt('modeline', false, buffer)
opt('signcolumn', 'yes:1', window)
opt('ruler', true)
opt('number', true)
opt('clipboard', 'unnamedplus')

-- Colorscheme
opt('termguicolors', true)
cmd [[colorscheme dracula]]
