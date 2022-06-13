local M = {}

M.aerial = require('aerial')

M.opts = {
  -- Enum: persist, close, auto, global
  --   persist - aerial window will stay open until closed
  --   close   - aerial window will close when original file is no longer visible
  --   auto    - aerial window will stay open as long as there is a visible
  --             buffer to attach to
  --   global  - same as 'persist', and will always show symbols for the current buffer
  close_behavior = 'close',
  -- Set to false to remove the default keybindings for the aerial buffer
  default_bindings = false,
  -- Disable aerial on files with this many lines
  disable_max_lines = 8192,
  -- A list of all symbols to display. Set to false to display all symbols.
  -- This can be a filetype map (see :help aerial-filetype-map)
  -- To see all available values, see :help SymbolKind
  filter_kind = false,
  -- Define symbol icons. You can also specify '<Symbol>Collapsed' to change the
  -- icon when the tree is collapsed at that symbol, or 'Collapsed' to specify a
  -- default collapsed icon. The default icon set is determined by the
  -- 'nerd_font' option below.
  -- If you have lspkind-nvim installed, aerial will use it for icons.
  icons = require('utils.shared').icons,
  -- Control which windows and buffers aerial should ignore.
  -- If close_behavior is 'global', focusing an ignored window/buffer will
  -- not cause the aerial window to update.
  -- If open_automatic is true, focusing an ignored window/buffer will not
  -- cause an aerial window to open.
  -- If open_automatic is a function, ignore rules have no effect on aerial
  -- window opening behavior; it's entirely handled by the open_automatic
  -- function.
  ignore = {
    -- List of filetypes to ignore.
    filetypes = { 'aerial', 'NvimTree', 'help', 'alpha', 'undotree', 'TelescopePrompt' },
  },
  on_attach = function(bufnr)
    local opt = { noremap = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>aa', '<cmd>AerialToggle<CR>', opt)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ao', '<cmd>AerialOpen<CR>', opt)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>aq', '<cmd>AerialClose<CR>', opt)
  end,
  -- When you fold code with za, zo, or zc, update the aerial tree as well.
  -- Only works when manage_folds = true
  link_folds_to_tree = true,
  -- Fold code when you open/collapse symbols in the tree.
  -- Only works when manage_folds = true
  link_tree_to_folds = true,
  -- Use symbol tree for folding. Set to true or false to enable/disable
  -- 'auto' will manage folds if your previous foldmethod was 'manual'
  manage_folds = true,
  -- These control the width of the aerial window.
  -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
  -- min_width and max_width can be a list of mixed types.
  -- max_width = {40, 0.2} means 'the lesser of 40 columns or 20% of total'
  max_width = { 40, 0.2 },
  width = nil,
  min_width = 16,
  -- Show box drawing characters for the tree hierarchy
  show_guides = true,
  -- Options for opening aerial in a floating win
  float = { border = 'single' },
  treesitter = { update_delay = 10 },
  markdown = { update_delay = 10 }
}
-- Call the setup function to change the default behavior
M.aerial.setup(M.opts)

-- Integration with lsp
if require('utils.funcs').loaded('nvim-lsp-installer') then
  local lsp_cfg = require('plugin-configs.nvim-lsp-installer')
  local orig_on_attach = lsp_cfg.on_attach
  lsp_cfg.on_attach = function(client, bufnr)
    orig_on_attach(client, bufnr)
    M.aerial.on_attach(client, bufnr)
  end
  lsp_cfg.lsp_install_and_set()
end

return M
