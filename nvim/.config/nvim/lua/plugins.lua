local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
                install_path)
    execute 'packadd packer.nvim'
end

return require('packer').startup(function()
    -- Packer itself
    use 'wbthomason/packer.nvim'

    -- Themes
    use {'dracula/vim', as = 'dracula'}
    use {'challenger-deep-theme/vim', as = 'challenger-deep'}

    -- Fonts
    use {'kyazdani42/nvim-web-devicons'}
    use {'yamatsum/nvim-web-nonicons'}

    -- Some better window control
    use {'mhinz/vim-sayonara', cmd = 'Sayonara'}

    -- Indent
    use {'lukas-reineke/indent-blankline.nvim', branch = 'lua'}

    -- File finding
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }

    -- Terminal
    use {'voldikss/vim-floaterm'}

    -- Project Management/Sessions
    use {
        'dhruvasagar/vim-prosession',
        after = 'vim-obsession',
        requires = {{'tpope/vim-obsession', cmd = 'Prosession'}},
        config = [[require('config.prosession')]]
    }

    -- Undo tree
    use {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        config = [[vim.g.undotree_SetFocusWhenToggle = 1]]
    }

    -- Git
    use 'TimUntersberger/neogit'

    -- Git gutter
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('gitsigns').setup() end
    }

    -- Statusline
    use {'glepnir/galaxyline.nvim', branch = 'main'}

    -- LSP, Autocomplete, Hinting
    use {'neovim/nvim-lspconfig'}
    use {'nvim-lua/lsp-status.nvim'}
    use {'onsails/lspkind-nvim'}
    use {'glepnir/lspsaga.nvim'}
    use {'hrsh7th/nvim-compe'}

    -- Format
    use {'andrejlevkovitch/vim-lua-format'}

    -- Color picking
    use {'rrethy/vim-hexokinase', run = 'make hexokinase'}

    -- Syntax
    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'nvim-treesitter/nvim-treesitter-refactor',
            'nvim-treesitter/nvim-treesitter-textobjects'
        },
        run = ':TSUpdate'
    }
    use {
        'romgrk/nvim-treesitter-context',
        requires = {'nvim-treesitter/nvim-treesitter'}
    }

end)
