require('go').setup()
vim.g.go_fmt_command = "goimports"

vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.go"},
  callback = function()
    require('go.format').gofmt()
  end,
})

