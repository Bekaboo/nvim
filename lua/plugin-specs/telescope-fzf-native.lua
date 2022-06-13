return {
  'nvim-telescope/telescope-fzf-native.nvim',
  run = 'make',
  config = function() require('plugin-configs.telescope-fzf-native') end
}
