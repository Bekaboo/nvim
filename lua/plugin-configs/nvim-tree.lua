local M = {}

vim.keymap.set('n', '<Leader>tt', function() require('nvim-tree').toggle(false, false) end, { noremap = true })
vim.keymap.set('n', '<Leader>tc', function() require('nvim-tree.actions.copy-paste').print_clipboard() end, { noremap = true })
vim.keymap.set('n', '<Leader>tq', function() require('nvim-tree.view').close() end, { noremap = true })
vim.keymap.set('n', '<Leader>tff', function() require('nvim-tree').find_file(true) end, { noremap = true })
vim.keymap.set('n', '<Leader>tft', function() require('nvim-tree').toggle(true, false) end, { noremap = true })
vim.keymap.set('n', '<Leader>to', function() require('nvim-tree').open() end, { noremap = true })
vim.keymap.set('n', '<Leader>tr', function() require('nvim-tree.actions.reloaders').reload_explorer() end, { noremap = true })

M.nvim_tree = require('nvim-tree')
M.opts = {
  view = {
    auto_resize = true,
    mappings = {
      list = {
        { key = '<C-[>', action = 'dir_up' },
        { key = '<M-v>', action = 'vsplit' },
        { key = '<M-s>', action = 'split' },
        { key = '<M-t>', action = 'tabnew' },
        { key = '{', action = 'first_sibling' },
        { key = '}', action = 'last_sibling' },
        { key = 'X', action = 'remove' },
        { key = 'W', action = '' },
        { key = 'zM', action = 'collapse_all' },
      }
    }
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      error = ' ',   -- xf659
      warning = ' ', -- xf529
      info = ' ',    -- xf7fc
      hint = ' ',    -- xf835
    }
  },
  renderer = {
    highlight_opened_files = 'name',
    indent_markers = { enable = true },
    icons = {
      glyphs = {
        git = {
          unstaged = '',
          staged = '',
          unmerged = '',
          renamed = '隷',
          deleted = '',
          untracked = '',
          ignored = ''
        },
        default = ''
      }
    }
  },
}
M.nvim_tree.setup(M.opts)

return M
