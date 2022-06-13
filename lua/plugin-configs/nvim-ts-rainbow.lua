if not require('utils.funcs').loaded('nvim-treesitter') then
  return
end

local M = {}

local ts_cfg = require('plugin-configs.nvim-treesitter')
M.opts = {
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1024
  }
}
ts_cfg.ts_configs.setup(M.opts)

return M
