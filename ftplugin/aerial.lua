local bufmap = vim.api.nvim_buf_set_keymap
local opt = { noremap = true }

vim.wo.spell = false
vim.wo.cursorcolumn = false

bufmap(0, 'n', '<leader>aa', '<cmd>AerialToggle<CR>', opt)
bufmap(0, 'n', '<leader>ao', '<cmd>AerialOpen<CR>', opt)
bufmap(0, 'n', '<leader>aq', '<cmd>AerialClose<CR>', opt)
bufmap(0, 'n', 'g?', [['<cmd>lua require'aerial'.bindings.show()<CR>]], opt)
bufmap(0, 'n', '<CR>', [[<cmd>lua require'aerial'.select()<CR>]], opt)
bufmap(0, 'n', '<M-v>', [[<cmd>lua require'aerial'.select({split='v'})<CR>]], opt)
bufmap(0, 'n', '<M-s>', [[<cmd>lua require'aerial'.select({split='h'})<CR>]], opt)
bufmap(0, 'n', '<C-v>', [[<cmd>lua require'aerial'.select({split='v'})<CR>]], opt)
bufmap(0, 'n', '<C-x>', [[<cmd>lua require'aerial'.select({split='h'})<CR>]], opt)
bufmap(0, 'n', '<Tab>', [[<cmd>lua require'aerial'.select({jump=false})<CR>]], opt)
bufmap(0, 'n', 'J', [[j<cmd>lua require'aerial'.select({jump=false})<CR>]], opt)
bufmap(0, 'n', 'K', [[k<cmd>lua require'aerial'.select({jump=false})<CR>]], opt)
bufmap(0, 'n', '{', '<cmd>AerialPrev<CR>', opt)
bufmap(0, 'n', '}', '<cmd>AerialNext<CR>', opt)
bufmap(0, 'n', '[[', '<cmd>AerialPrevUp<CR>', opt)
bufmap(0, 'n', ']]', '<cmd>AerialNextUp<CR>', opt)
bufmap(0, 'n', 'q', '<cmd>AerialClose<CR>', opt)
bufmap(0, 'n', 'zR', '<cmd>AerialTreeOpenAll<CR>', opt)
bufmap(0, 'n', 'zM', '<cmd>AerialTreeCloseAll<CR>', opt)
bufmap(0, 'n', 'zx', '<cmd>AerialTreeSyncFolds<CR>', opt)
bufmap(0, 'n', 'zX', '<cmd>AerialTreeSyncFolds<CR>', opt)
bufmap(0, 'n', 'za', '<cmd>AerialTreeToggle<CR>', opt)
bufmap(0, 'n', 'zA', '<cmd>AerialTreeToggle!<CR>', opt)
bufmap(0, 'n', 'zo', '<cmd>AerialTreeOpen<CR>', opt)
bufmap(0, 'n', 'zO', '<cmd>AerialTreeOpen!<CR>', opt)
bufmap(0, 'n', 'zc', '<cmd>AerialTreeClose<CR>', opt)
bufmap(0, 'n', 'zC', '<cmd>AerialTreeClose!<CR>', opt)
