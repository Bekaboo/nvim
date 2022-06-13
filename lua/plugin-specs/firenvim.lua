return {
  'glacambre/firenvim',
  run = function() vim.fn['firenvim#install'](0) end,
  cond = function() return vim.g.started_by_firenvim ~= nil end,
  config = function() require('plugin-configs.firenvim') end
}
