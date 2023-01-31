local function map(mappings)
  for _, mapping in ipairs(mappings) do
    vim.keymap.set(unpack(mapping))
  end
end

vim.keymap.set({ 'n', 'x', 'x' }, '<Space>', '')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

map({
  -- Multi-window operations
  { 'n', '<M-w>', '<C-w><C-w>' },
  { 'n', '<M-h>', '<C-w><C-h>' },
  { 'n', '<M-j>', '<C-w><C-j>' },
  { 'n', '<M-k>', '<C-w><C-k>' },
  { 'n', '<M-l>', '<C-w><C-l>' },
  { 'n', '<M-W>', '<C-w>W' },
  { 'n', '<M-H>', '<C-w>H' },
  { 'n', '<M-J>', '<C-w>J' },
  { 'n', '<M-K>', '<C-w>K' },
  { 'n', '<M-L>', '<C-w>L' },
  { 'n', '<M-=>', '<C-w>=' },
  { 'n', '<M-->', '<C-w>-' },
  { 'n', '<M-+>', '<C-w>+' },
  { 'n', '<M-_>', '<C-w>_' },
  { 'n', '<M-|>', '<C-w>|' },
  { 'n', '<M-<>', '<C-w><' },
  { 'n', '<M->>', '<C-w>>' },
  { 'n', '<M-p>', '<C-w>p' },
  { 'n', '<M-r>', '<C-w>r' },
  { 'n', '<M-v>', '<C-w>v' },
  { 'n', '<M-s>', '<C-w>s' },
  { 'n', '<M-x>', '<C-w>x' },
  { 'n', '<M-z>', '<C-w>z' },
  { 'n', '<M-c>', '<C-w>c' },
  { 'n', '<M-n>', '<C-w>n' },
  { 'n', '<M-o>', '<C-w>o' },
  { 'n', '<M-t>', '<C-w>t' },
  { 'n', '<M-T>', '<C-w>T' },
  { 'n', '<M-]>', '<C-w>]' },
  { 'n', '<M-^>', '<C-w>^' },
  { 'n', '<M-b>', '<C-w>b' },
  { 'n', '<M-d>', '<C-w>d' },
  { 'n', '<M-f>', '<C-w>f' },
  { 'n', '<M-g><M-]>', '<C-w>g<C-]>' },
  { 'n', '<M-g>]', '<C-w>g]' },
  { 'n', '<M-g>}', '<C-w>g}' },
  { 'n', '<M-g>f', '<C-w>gf' },
  { 'n', '<M-g>F', '<C-w>gF' },
  { 'n', '<M-g>t', '<C-w>gt' },
  { 'n', '<M-g>T', '<C-w>gT' },
  { 'n', '<M-g><Tab>', '<C-w>g<Tab>' },
  { 'n', '<M-}>', '<C-w>}' },

  -- Multi-buffer operations
  { 'n', '<Tab>', '<cmd>bn<CR>' },
  { 'n', '<S-Tab>', '<cmd>bp<CR>' },
  -- Delete current buffer
  { 'n', '<M-C>', '<cmd>bd<CR>' },
  -- <Tab> / <C-i> is used to switch buffers,
  -- so use <C-n> to jump to newer cursor position instead
  { 'n', '<C-n>', '<C-i>' },

  -- Moving in insert and command-line mode
  { '!', '<C-b>', '<Left>' },
  { '!', '<C-f>', '<Right>' },
  { '!', '<C-a>', '<Home>' },
  { '!', '<C-e>', '<End>' },
  { 'i', '<C-k>', '<C-o>D' },
  { 'c', '<C-k>', '<C-\\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>' },
  { '!', '<C-d>', '<Del>' },

  -- Enter normal mode from arbitrary mode
  { { 'n', 't', 'v', 'i', 'c' }, '<M-\\>', '<C-\\><C-n>' },

  -- Close all floating windows
  { 'n', 'q', '<Cmd>lua require("utils.funcs").close_all_floatings("q")<CR>' },

  -- Toggle background
  { 'n', '<M-D>', '<Cmd>if &background=="dark" | set background=light | ' ..
                  'else | set background=dark | endif<CR>' }
})
