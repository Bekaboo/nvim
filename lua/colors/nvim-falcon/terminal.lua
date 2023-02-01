local utils = require('colors.nvim-falcon.utils')
local plt = utils.reload('colors.nvim-falcon.palette')

local termcolors = {}

termcolors.dark = {
  terminal_color_0  = plt.ocean,
  terminal_color_8  = plt.white,
  terminal_color_1  = plt.ochre,
  terminal_color_9  = plt.ochre,
  terminal_color_2  = plt.tea,
  terminal_color_10 = plt.tea,
  terminal_color_3  = plt.yellow,
  terminal_color_11 = plt.yellow,
  terminal_color_4  = plt.cumulonimbus,
  terminal_color_12 = plt.cumulonimbus,
  terminal_color_5  = plt.lavender,
  terminal_color_13 = plt.lavender,
  terminal_color_6  = plt.aqua,
  terminal_color_14 = plt.aqua,
  terminal_color_7  = plt.white,
  terminal_color_15 = plt.pigeon,
}

termcolors.light = {
  terminal_color_0  = plt.ocean,
  terminal_color_8  = plt.white,
  terminal_color_1  = plt.ochre,
  terminal_color_9  = plt.ochre,
  terminal_color_2  = plt.tea,
  terminal_color_10 = plt.tea,
  terminal_color_3  = plt.yellow,
  terminal_color_11 = plt.yellow,
  terminal_color_4  = plt.flashlight,
  terminal_color_12 = plt.turquoise,
  terminal_color_5  = plt.lavender,
  terminal_color_13 = plt.lavender,
  terminal_color_6  = plt.aqua,
  terminal_color_14 = plt.aqua,
  terminal_color_7  = plt.white,
  terminal_color_15 = plt.pigeon,
}

return termcolors[vim.o.background or 'dark']
