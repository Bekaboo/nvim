return {
  'Bekaboo/falcon',
  cond = function()
    return vim.g.default_colorscheme == 'falcon'
  end,
  config = function() require('plugin-configs.falcon') end
}
