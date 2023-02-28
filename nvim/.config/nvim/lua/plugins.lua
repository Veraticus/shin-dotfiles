-- Much of this from: https://github.com/wbthomason/dotfiles/blob/linux/neovim/.config/nvim/lua/plugins.lua

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
local packer = nil
local function init()
  if packer == nil then
    packer = require 'packer'

    packer.init{
      disable_commands = true,
      display = {
        open_fn = function()
          local result, win, buf = require('packer.util').float {
            border = {
              { '╭', 'FloatBorder' },
              { '─', 'FloatBorder' },
              { '╮', 'FloatBorder' },
              { '│', 'FloatBorder' },
              { '╯', 'FloatBorder' },
              { '─', 'FloatBorder' },
              { '╰', 'FloatBorder' },
              { '│', 'FloatBorder' },
            },
          }
          vim.api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:Normal')
          return result, win, buf
        end,
      },
      max_jobs = 8,
      git = {
          subcommands = {
            update = 'pull --ff-only --progress --rebase',
        },
      }
    }

    local use = packer.use
    packer.reset()

    use 'lewis6991/impatient.nvim'

    -- Packer itself
    use 'wbthomason/packer.nvim'

    use { 'tversteeg/registers.nvim', keys = { { 'n', '"' }, { 'i', '<c-r>' } } }

    -- Movement
    use 'chaoren/vim-wordmotion'
    use 'mhinz/vim-sayonara'
    use {
      {
        'ggandor/leap.nvim',
        requires = 'tpope/vim-repeat',
      },
      { 'ggandor/flit.nvim', config = [[require'flit'.setup{}]] },
    }

    -- Quickfix
    use { 'Olical/vim-enmasse', cmd = 'EnMasse' }
    use 'kevinhwang91/nvim-bqf'
    use {
      'https://gitlab.com/yorickpeterse/nvim-pqf',
      config = function()
        require('pqf').setup()
      end,
    }

    -- Commenting
    use {
      'numToStr/Comment.nvim',
      event = 'User ActuallyEditing',
      config = function()
        require('Comment').setup {}
      end,
    }

    -- Wrapping/delimiters
    use {
      { 'machakann/vim-sandwich', event = 'User ActuallyEditing' },
      { 'andymass/vim-matchup', setup = [[require('config.matchup')]], event = 'User ActuallyEditing' },
    }
   
    -- Helpers
    use {'nvim-lua/popup.nvim'}
    use {'nvim-lua/plenary.nvim'}

    -- Themes
    -- use {'git@github.com:Veraticus/dracula_pro.nvim'}
    use {
      "catppuccin/nvim",
      as = "catppuccin",
      run = ":CatppuccinCompile",
      config = [[require('config.cattpuccin')]]
    }

    -- UI
    use 'stevearc/dressing.nvim'
    use 'rcarriga/nvim-notify'
    use 'vigoux/notifier.nvim'
    use {
      'folke/todo-comments.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('todo-comments').setup {}
      end,
    }

    use {
      'j-hui/fidget.nvim',
      config = function()
        require('fidget').setup {
          sources = {
            ['null-ls'] = { ignore = true },
          },
        }
      end,
    }

    -- Fonts
    use {'yamatsum/nvim-web-nonicons'}

    -- Prettification
    use { 'junegunn/vim-easy-align', disable = true }

     -- Text objects
    use 'wellle/targets.vim'

    -- Search
    use {
      {
        'nvim-telescope/telescope.nvim',
        requires = {
          'nvim-lua/popup.nvim',
          'nvim-lua/plenary.nvim',
          'telescope-frecency.nvim',
          'telescope-fzf-native.nvim',
          'nvim-telescope/telescope-ui-select.nvim',
        },
        wants = {
          'popup.nvim',
          'plenary.nvim',
          'telescope-frecency.nvim',
          'telescope-fzf-native.nvim',
        },
        setup = [[require('config.telescope_setup')]],
        config = [[require('config.telescope')]],
        cmd = 'Telescope',
        module = 'telescope',
      },
      {
        'nvim-telescope/telescope-frecency.nvim',
        after = 'telescope.nvim',
        requires = 'tami5/sqlite.lua',
      },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
      },
      'crispgm/telescope-heading.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    }

    -- File browsing
    use 'justinmk/vim-dirvish'
    use {'kristijanhusak/vim-dirvish-git'}
    use {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      config = [[vim.g.neo_tree_remove_legacy_commands = true]],
      requires = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
      },
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
    use {
      {
        'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = [[require('config.gitsigns')]],
        event = 'User ActuallyEditing',
      },
      { 'TimUntersberger/neogit', cmd = 'Neogit', config = [[require('config.neogit')]] },
      {
        'akinsho/git-conflict.nvim',
        tag = '*',
        config = function()
          require('git-conflict').setup()
        end,
      },
    }

    -- Statusline
    use {
      'hoob3rt/lualine.nvim',
      config = [[require('config.lualine')]],
    }

    -- Snippets
    use {
      {
        'L3MON4D3/LuaSnip',
        event = 'InsertEnter',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
      'rafamadriz/friendly-snippets',
    }

    -- LSP, Autocomplete, Hinting
    use {
      'neovim/nvim-lspconfig',
      config = [[require('config.lsp')]],
    }
    use {'barreiroleo/ltex-extra.nvim'}
    use {'folke/trouble.nvim'}
    use {'ray-x/lsp_signature.nvim'}
    use {'nvim-lua/lsp-status.nvim'}
    use {'kosayoda/nvim-lightbulb',  requires = 'antoinemadec/FixCursorHold.nvim'}
    use {
      'hrsh7th/nvim-cmp',
      requires = {
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        'hrsh7th/cmp-nvim-lsp',
        'onsails/lspkind.nvim',
        { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        'lukas-reineke/cmp-under-comparator',
        'hrsh7th/cmp-cmdline',
        { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
      },
      config = [[require('config.cmp')]],
      event = 'InsertEnter',
      after = 'LuaSnip',
    }
    use {
      'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
      config = function()
        require('lsp_lines').setup()
        -- Disable virtual_text since it's redundant due to lsp_lines.
        vim.diagnostic.config({
          virtual_text = false,
        })
      end,
    }

    -- Go
    use {
      'ray-x/go.nvim',
      config = [[require('config.go')]],
    }
    use 'ray-x/guihua.lua'

    -- Profiling
    use { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 10]] }

    -- Refactoring
    use { 'ThePrimeagen/refactoring.nvim', disable = true }

    -- Plugin development
    use 'folke/neodev.nvim'

    -- Format
    use {'Raimondi/delimitMate'}
    use {'cappyzawa/trim.nvim'}
    use {'lukas-reineke/format.nvim'}

    -- Syntax
    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'RRethy/nvim-treesitter-textsubjects',
            'nvim-treesitter/nvim-treesitter-refactor',
            'nvim-treesitter/nvim-treesitter-textobjects'
        },
        run = ':TSUpdate',
        config = [[require('config.treesitter')]]
    }

    -- Indent
    use {
      'lukas-reineke/indent-blankline.nvim',
      config = [[require('config.indent-blankline')]],
    }

    -- Buffer management
    use {
      'akinsho/bufferline.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      config = [[require('config.bufferline')]],
      event = 'User ActuallyEditing',
    }

    use {
      'b0o/incline.nvim',
      config = function()
        require('incline').setup {}
      end,
    }

    use {
      'filipdutescu/renamer.nvim',
      branch = 'master',
      requires = { { 'nvim-lua/plenary.nvim' } },
      config = function()
        require('renamer').setup {}
      end,
    }

    use {
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
      config = [[require('config.null-ls')]],
    }

    -- Open files at the last edited location
    use {
      'ethanholz/nvim-lastplace',
      config = function()
        require('nvim-lastplace').setup {}
      end,
    }
  end
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
