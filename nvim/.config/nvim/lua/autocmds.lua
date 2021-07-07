vim.api.nvim_command([[
autocmd BufNewFile,BufRead *.tf     setfiletype terraform
autocmd BufNewFile,BufRead *.tfvars setfiletype terraform
autocmd BufRead,BufNewFile [Dd]ockerfile set ft=Dockerfile
autocmd BufRead,BufNewFile Dockerfile* set ft=Dockerfile
autocmd BufRead,BufNewFile [Dd]ockerfile.vim set ft=vim
autocmd BufRead,BufNewFile *.dock set ft=Dockerfile
autocmd BufRead,BufNewFile *.[Dd]ockerfile set ft=Dockerfile
]])
