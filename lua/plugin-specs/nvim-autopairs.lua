return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function() require('plugin-configs.nvim-autopairs') end
}
