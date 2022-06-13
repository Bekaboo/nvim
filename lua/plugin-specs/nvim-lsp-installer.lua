return {
  'williamboman/nvim-lsp-installer',

  cmd = {
    'LspInstallInfo', 'LspInstall', 'LspUninstall', 'LspUninstallAll',
    'LspInstallLog', 'LspPrintInstalled'
  },
  requires = require('plugin-specs.nvim-lspconfig'),

  -- If cmp-nvim-lsp is installed then this
  -- plugin should be loaded after cmp-nvim-lsp
  after = 'nvim-lspconfig',
  config = function() require('plugin-configs.nvim-lsp-installer') end
}
