return {
  'ZSaberLv0/ZFVimIM',
  keys = {
    { 'i', '<C-Space>' }, { 'c', '<C-Space>' },
    { 'v', '<C-Space>' }, { 'n', '<C-Space>' }
  },
  requires = {
    require('plugin-specs.ZFVimIM_openapi'),
    require('plugin-specs.ZFVimJob'),
    require('plugin-specs.ZFVimGitUtil'),
    require('plugin-specs.ZFVimIM_pinyin_personal')
  },
  setup = [[
    vim.g.ZFVimIM_keymap = 0
    vim.g.ZFVimIM_openapi_enable = 1
    vim.g.ZFVimIM_openapi_word_type = 'sentence'
  ]], -- Do not set default keymap
  config = function() require('plugin-configs.ZFVimIM') end
}
