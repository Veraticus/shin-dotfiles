require'bufferline'.setup {
  options = {
    diagnostics = "nvim_lsp",
    show_buffer_close_icons = false,
    show_close_icon = false
  },
  highlights = require("catppuccin.groups.integrations.bufferline").get()
}

local map = vim.api.nvim_set_keymap

map('n', '[b', '<cmd>BufferLineCyclePrev<cr>', {silent = true, nowait = true})
map('n', ']b', '<cmd>BufferLineCycleNext<cr>', {silent = true, nowait = true})
