if not require('utils.funcs').loaded('telescope.nvim') then
  return
end

local M = {}

local telescope_cfg = require('plugin-configs.telescope')
M.opts = {
  extensions = {
    project = {
      base_dirs = { '~/' },
      hidden_files = true
    }
  }
}
telescope_cfg.telescope.setup(M.opts)
telescope_cfg.telescope.load_extension('project')

return M
