return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'BufEnter',
  requires = {
    require('plugin-specs.nvim-treesitter'),    -- To identify functions, methods, etc
    require('plugin-specs.vim-sleuth')          -- To automatically detect indentation
 },
  config = function() require('plugin-configs.indent-blankline') end
}
