vim.api.nvim_command([[
autocmd BufWrite *.lua call LuaFormat()
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
]])
