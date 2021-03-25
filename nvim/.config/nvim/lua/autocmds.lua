vim.api.nvim_command([[
autocmd BufWrite *.lua call LuaFormat()
]])

