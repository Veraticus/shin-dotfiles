vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_char = '▏'
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_context_patterns =
    {
        'class', 'function', 'method', '^if', '^while', '^for', '^object',
        '^table', 'block', 'arguments'
    }
vim.g.indent_blankline_buftype_exclude = {'terminal'}
vim.g.indent_blankline_filetype_exclude =
    {'help', 'startify', 'dashboard', 'packer'}
