-- Showing defaults
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
require'nvim-lightbulb'.update_lightbulb {
    sign = {enabled = false, priority = 10},
    float = {enabled = true, text = "💡", win_opts = {}},
    virtual_text = {enabled = true, text = "💡"}
}
