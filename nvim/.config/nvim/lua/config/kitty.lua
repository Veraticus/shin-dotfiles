vim.api.nvim_command([[
function! KittyBufferHistoryClean()
  set modifiable
  set noconfirm
  set nonumber
  set norelativenumber
  set signcolumn=no
  " clean ascii/ansi code  (starts with ^[)
  silent! %s/\e\[[0-9:;]*m//g
  silent! %s/[^[:alnum:][:punct:][:space:\]\]//g
  silent! %s/\e\[[^\s]*\s//g
  " remove empty spaces from end
  silent! %s/\s*$//
  silent! %s/\r*$//
  silent! %s/\n*$//
  let @/ = ""
  " map q to force quit
  cnoremap q q!
endfunction
command! KittyBufferHistoryClean call KittyBufferHistoryClean()
]])

