local M = {}

M.neorg = require('neorg')
M.opts = {
  load = {
    ['core.defaults'] = {}
  }
}
M.neorg.setup(M.opts)

return M
