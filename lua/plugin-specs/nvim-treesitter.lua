return {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  requires = {
    require('plugin-specs.nvim-ts-rainbow'),
    require('plugin-specs.nvim-ts-context-commentstring'),
    require('plugin-specs.nvim-treesitter-textobjects'),
  },
  config = function() require('plugin-configs.nvim-treesitter') end
}
