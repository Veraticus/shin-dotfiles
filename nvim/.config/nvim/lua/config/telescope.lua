require('telescope').setup {
  defaults = {
    prompt_prefix = '🔍 ',
    file_ignore_patterns = {
      '.git/',
    },
    dynamic_preview_title = true,
    vimgrep_arguments = {
      'rg',
      '--ignore',
      '--hidden',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
    },
  },
  pickers = {
    buffers = {
      prompt_title = '✨ Search Buffers ✨',
      sort_mru = true,
      preview_title = false,
    }
  }
}

require('telescope').load_extension('fzf')

local utils = require('utils')
local map = utils.map
map('n', '<C-f>', [[<cmd>lua require('telescope.builtin').find_files()<cr>]],
    {silent = true, nowait = true, noremap = true})
map('n', '<leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]],
    {silent = true, nowait = true, noremap = true})
map('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<cr>]],
    {silent = true, nowait = true, noremap = true})
map('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]],
    {silent = true, nowait = true, noremap = true})

