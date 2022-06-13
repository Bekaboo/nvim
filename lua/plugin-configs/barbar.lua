-- Move to previous/next
vim.api.nvim_set_keymap('n', '<S-Tab>', '<cmd>BufferPrevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Tab>', '<cmd>BufferNext<CR>', { noremap = true, silent = true })
-- Re-order to previous/next
vim.api.nvim_set_keymap('n', '<M-<>', '<cmd>BufferMovePrevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M->>', '<cmd>BufferMoveNext<CR>', { noremap = true, silent = true })
-- Goto buffer in position...
vim.api.nvim_set_keymap('n', '<M-1>', '<cmd>BufferGoto 1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-2>', '<cmd>BufferGoto 2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-3>', '<cmd>BufferGoto 3<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-4>', '<cmd>BufferGoto 4<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-5>', '<cmd>BufferGoto 5<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-6>', '<cmd>BufferGoto 6<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-7>', '<cmd>BufferGoto 7<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-8>', '<cmd>BufferGoto 8<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-9>', '<cmd>BufferGoto 9<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-$>', '<cmd>BufferLast<CR>', { noremap = true, silent = true })
-- Delete buffer
vim.api.nvim_set_keymap('n', '<M-C>', '<cmd>BufferClose<CR>', { noremap = true, silent = true }) -- Similar but better than `:bd`
-- Pin/Unpin buffer
vim.api.nvim_set_keymap('n', '<M-P>', '<cmd>BufferPin<CR>', { noremap = true, silent = true })
-- Wipeout buffer
-- map('n', '???', '<cmd>BufferWipeout<CR>', opts)
-- Close commands
vim.api.nvim_set_keymap('n', '<M-O>', '<cmd>BufferCloseAllButCurrentOrPinned<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-(>', '<cmd>BufferCloseBuffersLeft<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-)>', '<cmd>BufferCloseBuffersRight<CR>', { noremap = true, silent = true })
-- Magic buffer-picking mode
vim.api.nvim_set_keymap('n', '<M-S>', '<cmd>BufferPick<CR>', { noremap = true, silent = true })
-- Sort automatically by...
-- vim.api.nvim_set_keymap('n', '<Leader>bb', '<cmd>BufferOrderByBufferNumber<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<Leader>bd', '<cmd>BufferOrderByDirectory<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<Leader>bl', '<cmd>BufferOrderByLanguage<CR>', { noremap = true, silent = true })

-- Set barbar's options
vim.g.bufferline = {
  -- Enable/disable animations
  animation = false,
  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = true,
  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,
  -- Enable/disable close button
  closable = true,
  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,
  -- Enable/disable icons
  -- if set to 'numbers', will show buffer index in the tabline
  -- if set to 'both', will show buffer index and icons in the tabline
  icons = 'both',
  -- If set, the icon color will follow its corresponding buffer
  -- highlight group. By default, the Buffer*Icon group is linked to the
  -- Buffer* group (see Highlighting below). Otherwise, it will take its
  -- default value as defined by devicons.
  icon_custom_colors = false,
  -- Configure icons on the bufferline.
  icon_separator_active = '▌',
  icon_separator_inactive = '▌',
  icon_close_tab = '',
  icon_close_tab_modified = '[+]',
  icon_pinned = '車',
  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,
  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,
  -- Sets the maximum buffer name length.
  maximum_length = 30,
  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,
  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
  -- Sets the name of unnamed buffers. By default format is '[Buffer X]'
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil
}

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
