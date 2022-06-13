local M = {}

vim.cmd
[[
command XO Trouble
command XR TroubleRefresh
command XX TroubleToggle
command Xw TroubleToggle workspace_diagnostics
command Xd TroubleToggle document_diagnostics
command Xq TroubleToggle quickfix
command Xl TroubleToggle loclist
command Xr TroubleToggle lsp_references
]]

M.trouble = require('trouble')
M.opts = {
  action_keys = {
    -- key mappings for actions in the trouble list
    -- map to {} to remove a mapping, for example:
    -- close = {},
    close = 'q',                    -- close the list
    cancel = '<esc>',               -- cancel the preview and get back to your last window / buffer / cursor
    refresh = 'R',                  -- manually refresh
    jump = { '<Tab>' },             -- jump to the diagnostic or open / close folds
    jump_close = { '<CR>' },        -- jump to the diagnostic and close the list
    open_split = { '<M-s>' },       -- open buffer in new split
    open_vsplit = { '<M-v>' },      -- open buffer in new vsplit
    open_tab = { '<M-t>' },         -- open buffer in new tab
    toggle_mode = 'tm',             -- toggle between 'workspace' and 'document' diagnostics mode
    toggle_preview = 'tp',          -- toggle auto_preview
    preview = 'p',                  -- preview the diagnostic location
    hover = 'h',                    -- opens a small popup with the full multiline message
    close_folds = { 'zC', 'zc' },   -- close all folds
    open_folds = { 'zO', 'zo' },    -- open all folds
    toggle_fold = { 'zA', 'za' },   -- toggle fold of current file
    previous = { 'k', '<C-p>' },    -- preview item
    next = { 'j', '<C-n>' }         -- next item
  },
  indent_lines = true,              -- add an indent guide below the fold icons
  auto_open = false,                -- automatically open the list when you have diagnostics
  auto_close = false,               -- automatically close the list when you have no diagnostics
  auto_preview = true,              -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
  auto_fold = false,                -- automatically fold a file trouble list at creation
  auto_jump = { 'lsp_definitions' },-- for the given modes, automatically jump if there is only a single result
  use_diagnostic_signs = true -- enabling this will use the signs defined in your lsp client
}
M.trouble.setup(M.opts)

return M
