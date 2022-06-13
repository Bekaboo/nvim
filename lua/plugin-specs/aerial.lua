return {
  'stevearc/aerial.nvim',
  requires = {
    require('plugin-specs.nvim-lspconfig'),
    require('plugin-specs.nvim-lsp-installer'),
    require('plugin-specs.nvim-treesitter')
  },
  after = 'nvim-lsp-installer',
  config = function() require('plugin-configs.aerial') end,
}
