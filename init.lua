-- Initialize packer
require('packer').startup(function(use)
  -- Package Manager
  use 'wbthomason/packer.nvim'

  -- Essential Plugins
  use 'nvim-lua/plenary.nvim'            -- Useful Lua functions used by lots of plugins
  use 'nvim-tree/nvim-web-devicons'      -- File icons
  use 'MunifTanjim/nui.nvim'             -- UI Component Library
  use 'stevearc/dressing.nvim'           -- Improved UI for vim.ui interfaces

  -- LSP and Autocompletion
  use 'neovim/nvim-lspconfig'            -- LSP configurations
  use 'hrsh7th/nvim-cmp'                 -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'             -- LSP source for nvim-cmp

  -- Syntax Highlighting
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}  -- Treesitter for better syntax highlighting

  -- Telescope (Fuzzy Finder)
  use {'nvim-telescope/telescope.nvim', tag = '0.1.0'}

  -- Utility Plugins
  use 'max397574/better-escape.nvim'     -- Better escape mappings
  use 'nvim-lualine/lualine.nvim'        -- Status line
  use 'kyazdani42/nvim-tree.lua'         -- File explorer
  use 'numToStr/Comment.nvim'            -- Easy commenting
  use 'lewis6991/gitsigns.nvim'          -- Git integration
  use {'catppuccin/nvim', as = 'catppuccin'} -- Color scheme
  use 'lukas-reineke/indent-blankline.nvim' -- Indentation guides
  use 'windwp/nvim-autopairs'            -- Auto close pairs

  -- avante.nvim and its Dependencies
  use {
    'yetone/avante.nvim',
    config = function()
      require('avante').setup({
        -- Your avante.nvim configurations here
      })
    end,
    build = ':AvanteBuild',
    requires = {
      'HakonHarnes/img-clip.nvim',
      'MeanderingProgrammer/render-markdown.nvim',
      'zbirenbaum/copilot.lua', -- Optional: For GitHub Copilot integration
    }
  }
end)




-- Basic settings
vim.opt.number = true                   -- Show line numbers
vim.opt.relativenumber = true           -- Show relative numbers
vim.opt.expandtab = true                -- Use spaces instead of tabs
vim.opt.shiftwidth = 4                  -- Shift 4 spaces when tab
vim.opt.tabstop = 4                     -- 1 tab == 4 spaces
vim.opt.smartindent = true              -- Auto-indent new lines
vim.g.mapleader = " "                   -- Set space as the leader key
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ';', ':', { noremap = true, silent = false })
vim.cmd.colorscheme "catppuccin"      -- You already


local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Python
require('lspconfig').pyright.setup { capabilities = capabilities }
-- C/C++
require('lspconfig').clangd.setup { capabilities = capabilities }
-- Assembly
require('lspconfig').ccls.setup { capabilities = capabilities }

require("better_escape").setup {
    timeout = vim.o.timeoutlen,
    default_mappings = false,  -- Disable default mappings
    mappings = {
        i = { j = { k = "<Esc>" } },  -- jk to escape insert mode
    },
}
-- Treesitter configuration
require'nvim-treesitter.configs'.setup {
  highlight = { enable = true },
  indent = { enable = true },
}

-- nvim-cmp setup
local cmp = require'cmp'
cmp.setup({
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
  },
})

-- Telescope configuration
require('telescope').setup{
  defaults = {
    mappings = {
      i = { ["<C-n>"] = "move_selection_next", ["<C-p>"] = "move_selection_previous" },
    },
  }
}

-- Lualine setup
require('lualine').setup {
    options = {
        theme = 'catppuccin'
    }
}

-- Nvim-tree setup
require('nvim-tree').setup {}

-- Comment.nvim setup
require('Comment').setup()

-- Gitsigns setup
require('gitsigns').setup()

require('ibl').setup {}

require("nvim-autopairs").setup {}

-- avante.nvim deps
require('img-clip').setup ({
  -- use recommended settings from above
})
require('render-markdown').setup ({
  -- use recommended settings from above
})
require('avante').setup ({
  
})
