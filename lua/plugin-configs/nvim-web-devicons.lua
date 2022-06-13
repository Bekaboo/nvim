local M = {}

M.web_devicons = require('nvim-web-devicons')

M.opts = {
 override = {
  default_icon = {
    color = '#b4b4b9',
    cterm_color = '249',
    icon = '',
    name = 'Default'
  },
  desktop = {
    color = '#563d7c',
    cterm_color = '60',
    icon = 'ﲾ',
    name = 'DesktopEntry'
  },
 };
}

M.web_devicons.setup(M.opts)

return M
