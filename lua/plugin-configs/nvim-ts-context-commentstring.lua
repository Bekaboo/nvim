if not require('utils.funcs').loaded('nvim-treesitter') then
  return
end

local M = {}

local ts_cfg = require('plugin-configs.nvim-treesitter')
M.opts = { context_commentstring = { enable = true } }
ts_cfg.ts_configs.setup(M.opts)

return M
