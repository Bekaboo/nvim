return {
  'nvim-lualine/lualine.nvim',
  requires = require('plugin-specs.nvim-web-devicons'),
  config = function() require('plugin-configs.lualine') end
}
