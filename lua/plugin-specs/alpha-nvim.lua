return {
  'goolord/alpha-nvim',
  cmd = 'Alpha',
  requires = require('plugin-specs.nvim-web-devicons'),
  config = function() require('plugin-configs.alpha-nvim') end,
}
