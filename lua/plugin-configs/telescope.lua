local M = {}

M.telescope = require('telescope')
M.telescope_builtin = require('telescope.builtin')
M.telescope_actions = require('telescope.actions')

vim.keymap.set('n', '<Leader>F', function() M.telescope_builtin.builtin() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ff', function() M.telescope_builtin.find_files() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fof', function() M.telescope_builtin.oldfiles() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>f;', function() M.telescope_builtin.live_grep() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>f*', function() M.telescope_builtin.grep_string() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fh', function() M.telescope_builtin.help_tags() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fm', function() M.telescope_builtin.marks() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fq', function() M.telescope_builtin.quickfix() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fl', function() M.telescope_builtin.loclist() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fbf', function() M.telescope_builtin.current_buffer_fuzzy_find() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fR', function() M.telescope_builtin.lsp_references() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fa', function() M.telescope_builtin.lsp_code_actions() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fe', function() M.telescope_builtin.diagnostics() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fd', function() M.telescope_builtin.lsp_definitions() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ftd', function() M.telescope_builtin.lsp_type_definitions() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fi', function() M.telescope_builtin.lsp_implementations() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fp', function() M.telescope_builtin.treesitter() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fs', function() M.telescope_builtin.lsp_document_symbols() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fS', function() M.telescope_builtin.lsp_workspace_symbols() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fgs', function() M.telescope_builtin.git_status() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fgf', function() M.telescope_builtin.git_files() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fj', function() M.telescope.extensions.project.project({ display_type = 'full' }) end, { noremap = true, silent = true })

M.opts = {
  defaults = {
    prompt_prefix = '/ ',
    selection_caret = '→ ',
    borderchars = require('utils.shared').borders.double_header,
    layout_config = {
      horizontal = { prompt_position = 'top' },
      vertical = { prompt_position = 'top' }
    },
    sorting_strategy = 'ascending',
    file_ignore_patterns = { '.git/', '%.pdf', '%.o', '%.zip' },
    preview = { filesize_limit = 5 },
    mappings = {
      i = {
        ['<M-c>'] = M.telescope_actions.close,
        ['<M-s>'] = M.telescope_actions.select_horizontal,
        ['<M-v>'] = M.telescope_actions.select_vertical,
        ['<M-t>'] = M.telescope_actions.select_tab,
        ['<M-q>'] = M.telescope_actions.send_to_qflist + M.telescope_actions.open_qflist,
        ['<M-Q>'] = M.telescope_actions.send_selected_to_qflist + M.telescope_actions.open_qflist,
      },

      n = {
        ['q'] = M.telescope_actions.close,
        ['<esc>'] = M.telescope_actions.close,
        ['<M-c>'] = M.telescope_actions.close,
        ['<M-s>'] = M.telescope_actions.select_horizontal,
        ['<M-v>'] = M.telescope_actions.select_vertical,
        ['<M-t>'] = M.telescope_actions.select_tab,
        ['<M-q>'] = M.telescope_actions.send_to_qflist + M.telescope_actions.open_qflist,
        ['<M-Q>'] = M.telescope_actions.send_selected_to_qflist + M.telescope_actions.open_qflist,
        ['<C-n>'] = M.telescope_actions.move_selection_next,
        ['<C-p>'] = M.telescope_actions.move_selection_previous,
      }
    }
  },
}

M.telescope.setup(M.opts)

return M
