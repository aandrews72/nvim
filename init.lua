-- Initialize packer
require('packer').startup(function(use)
  -- Package Manager
  use 'wbthomason/packer.nvim'

  -- Essential Plugins
  use 'nvim-lua/plenary.nvim'                  -- Utility functions for Neovim plugins
  use 'nvim-tree/nvim-web-devicons'            -- File icons for plugins like Telescope and nvim-tree
  use 'MunifTanjim/nui.nvim'                   -- UI components
  use 'stevearc/dressing.nvim'                 -- Improved input and select UI

  -- LSP and Autocompletion
  use 'neovim/nvim-lspconfig'                  -- Configurations for built-in LSP
  use 'williamboman/mason.nvim'                -- Manage LSP servers, linters, and formatters
  use 'williamboman/mason-lspconfig.nvim'      -- Integrates Mason with nvim-lspconfig
  use 'hrsh7th/nvim-cmp'                       -- Autocompletion framework
  use 'hrsh7th/cmp-nvim-lsp'                   -- LSP source for nvim-cmp

  -- Treesitter
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'} -- Better syntax highlighting and more

  -- Telescope
  use {'nvim-telescope/telescope.nvim', tag = '0.1.0'} -- Fuzzy finder

  -- Utility Plugins
  use 'max397574/better-escape.nvim'           -- Smarter keybinding for leaving insert mode
  use 'nvim-lualine/lualine.nvim'              -- Statusline
  use 'kyazdani42/nvim-tree.lua'               -- File explorer
  use 'numToStr/Comment.nvim'                  -- Easy code commenting
  use 'lewis6991/gitsigns.nvim'                -- Git integration
  use {'catppuccin/nvim', as = 'catppuccin'}   -- Colorscheme
  use 'lukas-reineke/indent-blankline.nvim'    -- Indentation guides
  use 'windwp/nvim-autopairs'                  -- Automatically close brackets and quotes
  use 'ThePrimeagen/vim-be-good'
end)

-- Basic Settings
vim.opt.number = true                          -- Show line numbers
vim.opt.relativenumber = true                  -- Show relative line numbers
vim.opt.expandtab = true                       -- Use spaces instead of tabs
vim.opt.shiftwidth = 4                         -- Shift by 4 spaces when tabbing
vim.opt.tabstop = 4                            -- A tab is 4 spaces
vim.opt.smartindent = true                     -- Smart auto-indentation
vim.g.mapleader = " "                          -- Set space as the leader key
vim.opt.clipboard = "unnamedplus"              -- Use the system clipboard
vim.opt.updatetime = 300
vim.opt.lazyredraw = true

-- Key Mappings
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true }) -- Toggle file explorer
vim.api.nvim_set_keymap('n', ';', ':', { noremap = true, silent = false })                         -- Remap ; to :

-- Colorscheme
vim.cmd.colorscheme "catppuccin"

-- Diagnostics
vim.diagnostic.config({
  virtual_text = false,  -- Disable inline diagnostics
  underline = true,      -- Underline diagnostics
  signs = true,          -- Show signs in the gutter
  severity_sort = true,  -- Sort diagnostics by severity
  update_in_insert = false, -- Disable updates during insert mode
})

-- Mason Setup
require('mason').setup()

-- Mason LSP Config Setup
require('mason-lspconfig').setup {
  ensure_installed = { 'pylsp', 'clangd', 'asm_lsp', 'bashls', 'rust_analyzer', 'html', 'cssls','sqls', 'ts_ls'}, -- Automatically install these servers
}

-- LSP Configuration
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- Function that runs when LSP attaches to a buffer
local on_attach = function(client, bufnr)
  -- General LSP key mappings
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

  -- Highlight on hover
  if client.server_capabilities.documentHighlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Setup handlers for Mason-managed LSP servers
require('mason-lspconfig').setup_handlers({
  function (server_name)
    lspconfig[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end
})

-- High CPU Usage Fix
local ok, wf = pcall(require, "vim.lsp._watchfiles")
if ok then
  wf._watchfunc = function()
    return function() end
  end
end

-- Better Escape
require("better_escape").setup {
  timeout = vim.o.timeoutlen,
  default_mappings = false,
  mappings = { i = { j = { k = "<Esc>" } } },
}

-- Treesitter Configuration
require('nvim-treesitter.configs').setup {
  highlight = { enable = true },
  indent = { enable = true },
}

-- nvim-cmp Setup
local cmp = require('cmp')
cmp.setup({
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = { { name = 'nvim_lsp' } },
})

-- Telescope Configuration
require('telescope').setup{}

-- Lualine Configuration
require('lualine').setup { options = { theme = 'catppuccin' } }

-- NvimTree Configuration
require('nvim-tree').setup({
    git = {
        timeout = 1000,
    },
})

-- Comment.nvim Setup
require('Comment').setup()

-- Gitsigns Configuration
require('gitsigns').setup()

-- Indentation Guides
require('ibl').setup {}

-- Autopairs Configuration
require('nvim-autopairs').setup{}

