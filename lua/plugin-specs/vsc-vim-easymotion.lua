return {
  'asvetliakov/vim-easymotion',
  as = 'vsc-vim-easymotion',    -- Avoid name confliction
  -- Only this plugin when called by vscode
  cond = function () return (nil ~= vim.g.vscode) end,
  config = function() require('plugin-configs.vsc-vim-easymotion') end
}
