-- customize dracula color palette
vim.g.dracula_colors = {
  bg = 'NONE',
  fg = '#C5C7D6',
  selection = '#44475A',
  comment = '#6272A4',
  red = '#FF5555',
  orange = '#FFB86C',
  yellow = '#F9F6D4',
  green = '#50fa7b',
  purple = '#BD93F9',
  cyan = '#8BE9FD',
  white = '#DFE1F2',
  pink = '#FF79C6',
  bright_red = '#FF6E6E',
  bright_green = '#69FF94',
  bright_yellow = '#FFFFA5',
  bright_blue = '#D6ACFF',
  bright_magenta = '#FF92DF',
  bright_cyan = '#A4FFFF',
  bright_white = '#E6EEFF',
  menu = 'NONE',
  visual = '#2D1078',
  gutter_fg = '#4B5263',
  nontext = '#3B4048',
}

-- show the '~' characters after the end of buffers
vim.g.dracula_show_end_of_buffer = true
-- use transparent background
vim.g.dracula_transparent_bg = true
-- set custom lualine background color
vim.g.dracula_lualine_bg_color = '#44475a'
-- set italic comment
vim.g.dracula_italic_comment = false

if vim.g.default_colorscheme == 'dracula' then
  vim.cmd [[colorscheme dracula]]
end
