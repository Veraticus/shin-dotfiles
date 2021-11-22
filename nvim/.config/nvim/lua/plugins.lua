local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
                install_path)
    execute 'packadd packer.nvim'
end

require('packer').startup({function()
    use 'lewis6991/impatient.nvim'

    -- Movement
    use {'ggandor/lightspeed.nvim'}

    -- Packer itself
    use 'wbthomason/packer.nvim'

    -- Helpers
    use {'nvim-lua/popup.nvim'}
    use {'nvim-lua/plenary.nvim'}

    -- Themes
    use {'git@github.com:Veraticus/dracula_pro.nvim'}

    -- Fonts
    use {'kyazdani42/nvim-web-devicons'}
    use {'yamatsum/nvim-web-nonicons'}

    -- Some better window control
    use {'mhinz/vim-sayonara', cmd = 'Sayonara'}

    -- File finding
    use {
      'nvim-telescope/telescope.nvim',
      requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- File browsing
    use {'justinmk/vim-dirvish'}
    use {'kristijanhusak/vim-dirvish-git'}
    use {
      'phaazon/hop.nvim',
      branch = 'v1',
    }

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
    use {'hoob3rt/lualine.nvim'}

    -- LSP, Autocomplete, Hinting
    use {'neovim/nvim-lspconfig'}
    use {'nvim-lua/lsp-status.nvim'}
    use {'tami5/lspsaga.nvim'}
    use {'ms-jpq/coq_nvim', branch = 'coq'}
    use {'ms-jpq/coq.artifacts', branch = 'artifacts'}
    use {'kosayoda/nvim-lightbulb'}
    use {'kabouzeid/nvim-lspinstall'}
    use({
      'weilbith/nvim-code-action-menu',
      cmd = 'CodeActionMenu',
    })

    -- Format
    use {'Raimondi/delimitMate'}
    use {'cappyzawa/trim.nvim'}
    use {'lukas-reineke/format.nvim'}

    -- Color picking
    use {'rrethy/vim-hexokinase', run = 'make hexokinase'}

    -- Syntax
    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'RRethy/nvim-treesitter-textsubjects',
            'nvim-treesitter/nvim-treesitter-refactor',
            'nvim-treesitter/nvim-treesitter-textobjects'
        },
        run = ':TSUpdate'
    }

    -- Tpope
    use {'tpope/vim-commentary'}

    -- Indent
    use {'lukas-reineke/indent-blankline.nvim'}

    -- Terminal
    use {'voldikss/vim-floaterm'}

    -- Shortcuts
    use {'folke/which-key.nvim'}

    -- Bufferline
    use {'akinsho/nvim-bufferline.lua'}

  end,
  config = {
    -- Move to lua dir so impatient.nvim can cache it
    compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
  }})

require('packer_compiled')
require('impatient')
