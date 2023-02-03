local M = {}
local configs = require('modules.lsp.configs')
local ft_list = require('utils.static').langs:list('ft')

M['nvim-lspconfig'] = {
  'neovim/nvim-lspconfig',
  ft = ft_list,
  module = 'lspconfig',
  config = configs['nvim-lspconfig'],
}

M['clangd_extensions.nvim'] = {
  'p00f/clangd_extensions.nvim',
  ft = { 'c', 'cpp' },
  requires = 'nvim-lspconfig',
  config = configs['clangd_extensions.nvim'],
}

M['mason-lspconfig.nvim'] = {
  'williamboman/mason-lspconfig.nvim',
  requires = { 'mason.nvim', 'nvim-lspconfig', },
  ft = ft_list,
  config = configs['mason-lspconfig.nvim'],
}

M['fidget.nvim'] = {
  'j-hui/fidget.nvim',
  after = 'nvim-lspconfig',
  config = configs['fidget.nvim'],
}

return M
