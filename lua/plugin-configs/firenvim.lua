vim.o.showtabline = 0
vim.o.laststatus = 0
vim.o.number = false
vim.o.relativenumber = false
vim.o.wrap = true
vim.o.linebreak = true
vim.o.scrolloff = 1
vim.o.guifont = 'FiraCode NF Retina:h12'
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })
vim.keymap.set('n', '$', 'g$', { noremap = true })
vim.keymap.set('n', '0', 'g0', { noremap = true })
vim.keymap.set('n', '^', 'g^', { noremap = true })
-- Adjust input box size
vim.keymap.set('n', '<M-,>', '<cmd>let &columns-=v:count1<CR>', { noremap = true })
vim.keymap.set('n', '<M-.>', '<cmd>let &columns+=v:count1<CR>', { noremap = true })
vim.keymap.set('n', '<M-->', '<cmd>let &lines-=v:count1<CR>', { noremap = true })
vim.keymap.set('n', '<M-S-+>', '<cmd>let &lines+=v:count1<CR>', { noremap = true }) -- <M-+> is recognized as <M-S-+>
-- Delete a word in a browser in insert mode (<C-w> closes the tab page)
vim.keymap.set('!', '<C-BS>', '<C-w>', { noremap = true })
-- Set number and statusline, etc if the input box is large enough
vim.api.nvim_create_autocmd('BufNew', {
  pattern = '*',
  callback = function()
    if vim.o.columns >= 80 and vim.o.lines >= 20 then
      vim.o.laststatus = 3
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.wrap = false
      vim.o.linebreak = false
      vim.o.scrolloff = 8
    end
  end
})

-- Disable cmp
if require('utils.funcs').loaded('nvim-cmp') then
  require('cmp').setup({ enabled = false })
end
