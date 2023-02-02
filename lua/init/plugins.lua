local manage_plugins = require('utils.packer').manage_plugins

if vim.g.vscode then
  manage_plugins({
    root = vim.fn.stdpath('data') .. '/vscode_neovim',
    config = {
      display = {
        non_interactive = true,
      },
    },
    modules = {
      'base',
      'misc',
      'treesitter',
    },
  })
else
  manage_plugins({
    config = {
      display = {
        open_cmd = 'tabnew \\[packer\\]',
        working_sym = '',
        error_sym = '',
        done_sym = '',
        removed_sym = '',
        moved_sym = 'ﰲ',
        keybindings = {
          toggle_info = '<Tab>'
        },
      },
    },
    modules = {
      'base',
      'completion',
      'debug',
      'lsp',
      'markup',
      'misc',
      'tools',
      'treesitter',
      'ui',
    }
  })
end
