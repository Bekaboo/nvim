return {
  'Mofiqul/dracula.nvim',
  cond = function () return vim.g.default_colorscheme == 'dracula' end,
  config = function() require('plugin-configs.dracula') end
}
