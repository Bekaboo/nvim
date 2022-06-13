local M = {}

M.indent_blankline = require('indent-blankline')
M.opts = {
  space_char_blankline = ' ',
  show_current_context = true,
  filetype = require('utils.shared').langs:list('ft'),
  use_treesitter = true,
  show_trailing_blankline_indent = false,
  max_indent_increase = 1
}
M.indent_blankline.setup(M.opts)

return M
