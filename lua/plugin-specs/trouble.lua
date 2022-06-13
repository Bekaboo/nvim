return {
  'folke/trouble.nvim',
  cmd = {
    'Trouble', 'TroubleToggle', 'TroubleRefresh',
    'XO', 'XR', 'XX', 'Xw', 'Xd', 'Xq', 'Xl', 'Xr'
  },
  requires = require('plugin-specs.nvim-web-devicons'),
  config = function() require('plugin-configs.trouble') end
}
