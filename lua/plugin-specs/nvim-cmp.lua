return {
  'hrsh7th/nvim-cmp',
-- Remove this line if nvim complains 'cmp' not found
-- this error can occur when the plugin 'impatient' is
-- not loaded
  config = function() require('plugin-configs.nvim-cmp') end,
  requires = {
    require('plugin-specs.cmp-nvim-lsp'),
    require('plugin-specs.cmp-buffer'),
    require('plugin-specs.cmp-path'),
    require('plugin-specs.cmp-vsnip'),
    require('plugin-specs.vim-vsnip'),
    require('plugin-specs.cmp-calc'),
    require('plugin-specs.cmp-cmdline'),
    require('plugin-specs.cmp-emoji'),
    require('plugin-specs.cmp-spell'),
  },
}
