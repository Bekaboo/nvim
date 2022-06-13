return {
  'romgrk/barbar.nvim',
  event = 'BufAdd',
  requries = require('plugin-specs.nvim-web-devicons'),
  config = function() require('plugin-configs.barbar') end,
}
