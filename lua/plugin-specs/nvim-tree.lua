return {
  'kyazdani42/nvim-tree.lua',
  cmd = {
    'NvimTreeFindFile', 'NvimTreeFindFileToggle',
    'NvimTreeFocus', 'NvimTreeOpen', 'NvimTreeToggle',
  },
  keys = {
    '<Leader>tt', '<Leader>tff', '<Leader>tft', '<Leader>to'
  },
  requires = require('plugin-specs.nvim-web-devicons'),
  config = function() require('plugin-configs.nvim-tree') end,
}
