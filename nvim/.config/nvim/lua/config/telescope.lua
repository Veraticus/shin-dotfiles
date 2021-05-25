local utils = require('utils')
local opt = utils.opt
local autocmd = utils.autocmd
local map = utils.map
local icons = require('nvim-nonicons')

function input_grep()
    string = vim.fn.input("rg/")
    require('telescope.builtin').grep_string({search = string})
end
map('n', '<C-f>',
    [[<cmd>lua require('telescope.builtin').find_files{find_command={"rg", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--files", "--hidden", "--follow", "-g", "!.git/*"}}<cr>]])
map('n', '<leader>fg', [[<cmd>lua input_grep()<cr>]])
map('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<cr>]])

require('telescope').setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
        }
    },
    defaults = {
        vimgrep_arguments = {
            'rg', '--color=never', '--no-heading', '--with-filename',
            '--line-number', '--column', '--smart-case', '-uu', '-g', "!.git/*"
        },
        prompt_position = "bottom",
        prompt_prefix = "  " .. icons.get("telescope") .. "  ",
        selection_caret = "▶ ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_defaults = {
            horizontal = {mirror = false},
            vertical = {mirror = false}
        },
        file_sorter = require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
        shorten_path = true,
        winblend = 0,
        width = 0.75,
        preview_cutoff = 120,
        results_height = 1,
        results_width = 0.8,
        border = {},
        borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
        color_devicons = true,
        use_less = true,
        set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
    }
}

require('telescope').load_extension('fzf')
