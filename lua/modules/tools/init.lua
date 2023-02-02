local M = {}
local configs = require('modules/tools/configs')

M['mason.nvim'] = {
  'williamboman/mason.nvim',
  cmd = {
    'Mason',
    'MasonUninstall',
    'MasonLog',
    'MasonInstall',
    'MasonUninstallAll',
  },
  module = 'mason',
  config = configs['mason.nvim'],
}

M['telescope.nvim'] = {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  keys = {
    '<Leader>F', '<Leader>ff', '<Leader>fo', '<Leader>f;',
    '<Leader>f*', '<Leader>fh', '<Leader>fm', '<Leader>fb',
    '<Leader>fr', '<Leader>fa', '<Leader>fe', '<Leader>fp',
    '<Leader>fs', '<Leader>fS', '<Leader>fg', '<Leader>fm',
    '<Leader>fd', '<Leader>fu',
  },
  requires = {
    'plenary.nvim',
    'telescope-fzf-native.nvim'
  },
  config = configs['telescope.nvim'],
}

M['telescope-fzf-native.nvim'] = {
  'nvim-telescope/telescope-fzf-native.nvim',
  -- If it complains 'fzf doesn't exists, run 'make' inside
  -- the root folder of this plugin
  run = 'make',
  module = 'telescope._extensions.fzf',
  requires = 'telescope.nvim',
}

M['telescope-undo.nvim'] = {
  'debugloop/telescope-undo.nvim',
  module = 'telescope._extensions.undo',
  requires = { 'plenary.nvim', 'telescope.nvim' },
}

M['vim-floaterm'] = {
  'voldikss/vim-floaterm',
  keys = {
    { 'n', '<C-\\>' },
    { 't', '<C-\\>' },
    { 'n', '<M-i>' },
    { 't', '<M-i>' },
  },
  cmd = { 'FloatermNew', 'FloatermToggle', 'ToggleTool' },
  config = configs['vim-floaterm'],
}

M['gitsigns.nvim'] = {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPre',
  requires = 'plenary.nvim',
  config = configs['gitsigns.nvim'],
}

M['rnvimr'] = {
  'kevinhwang91/rnvimr',
  config = configs['rnvimr'],
}

M['tmux.nvim'] = {
  'aserowy/tmux.nvim',
  keys = { '<M-h>', '<M-j>', '<M-k>', '<M-l>' },
  config = configs['tmux.nvim'],
}

M['nvim-colorizer.lua'] = {
  'NvChad/nvim-colorizer.lua',
  event = { 'BufNew', 'BufRead' },
  config = configs['nvim-colorizer.lua'],
}

return M
