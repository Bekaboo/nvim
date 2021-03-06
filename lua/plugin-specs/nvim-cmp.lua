local get = require('utils.get')

return {
  'hrsh7th/nvim-cmp',
-- Remove this line if nvim complains 'cmp' not found
-- this error can occur when the plugin 'impatient' is
-- not loaded
  config = get.config('nvim-cmp'),
  requires = {
    get.spec('cmp-nvim-lsp'), get.spec('cmp-buffer'), get.spec('cmp-path'),
    get.spec('cmp-vsnip'), get.spec('vim-vsnip'), get.spec('cmp-calc'),
    get.spec('cmp-cmdline'), get.spec('cmp-emoji'), get.spec('cmp-spell'),
  }
}
