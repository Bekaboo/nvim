return {
  'easymotion/vim-easymotion',
  cond = function () return (nil == vim.g.vscode) end,
  config = function() require('plugin-configs.vim-easymotion') end
}
