return {
  -- Setting this plugin to optional might
  -- break telescope's mappings.execute_keymap?
  'github/copilot.vim',
  cmd = 'Copilot',
  setup = function()
    -- Avoid conflict with nvim-cmp's tab fallback
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ''
    vim.keymap.set('i', '<C-j>', [[copilot#Accept('')]],
        { noremap = true, silent = true, expr = true })
  end,
  config = function() require('plugin-configs.copilot') end
}
