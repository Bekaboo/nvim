return {
  'lewis6991/gitsigns.nvim',
  requires = {
    require('plugin-specs.plenary'),
    require('plugin-specs.vim-repeat')
  },
  config = function() require('plugin-configs.gitsigns') end,
}
