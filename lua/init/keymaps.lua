-- Map leader key to space
vim.keymap.set('n', '<Space>', '', {})
vim.g.mapleader = ' '

-- Map esc key
vim.keymap.set('i', 'jj', '<esc>', { noremap = true })

-- Exit from term mode
vim.keymap.set('t', '\\<C-\\>', '<C-\\><C-n>', { noremap = true })

-- Toggle hlsearch
vim.keymap.set('n', '\\', '<cmd>set hlsearch!<CR>', { noremap = true })
vim.keymap.set('n', '/', '/<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', '?', '?<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', '*', '*<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', '#', '#<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'g*', 'g*<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'g#', 'g#<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'n', 'n<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'N', 'N<cmd>set hlsearch<CR>', { noremap = true })

-- Multi-window operations
vim.keymap.set('n', '<M-w>', '<C-w><C-w>', { noremap = true })
vim.keymap.set('n', '<M-h>', '<C-w><C-h>', { noremap = true })
vim.keymap.set('n', '<M-j>', '<C-w><C-j>', { noremap = true })
vim.keymap.set('n', '<M-k>', '<C-w><C-k>', { noremap = true })
vim.keymap.set('n', '<M-l>', '<C-w><C-l>', { noremap = true })
vim.keymap.set('n', '<M-W>', '<C-w>W', { noremap = true })
vim.keymap.set('n', '<M-H>', '<C-w>H', { noremap = true })
vim.keymap.set('n', '<M-J>', '<C-w>J', { noremap = true })
vim.keymap.set('n', '<M-K>', '<C-w>K', { noremap = true })
vim.keymap.set('n', '<M-L>', '<C-w>L', { noremap = true })
vim.keymap.set('n', '<M-=>', '<C-w>=', { noremap = true })
vim.keymap.set('n', '<M-->', '<C-w>-', { noremap = true })
vim.keymap.set('n', '<M-+>', '<C-w>+', { noremap = true })
vim.keymap.set('n', '<M-_>', '<C-w>_', { noremap = true })
vim.keymap.set('n', '<M-|>', '<C-w>|', { noremap = true })
vim.keymap.set('n', '<M-,>', '<C-w><', { noremap = true })
vim.keymap.set('n', '<M-.>', '<C-w>>', { noremap = true })
vim.keymap.set('n', '<M-p>', '<C-w>p', { noremap = true })
vim.keymap.set('n', '<M-r>', '<C-w>r', { noremap = true })
vim.keymap.set('n', '<M-v>', '<C-w>v', { noremap = true })
vim.keymap.set('n', '<M-s>', '<C-w>s', { noremap = true })
vim.keymap.set('n', '<M-x>', '<C-w>x', { noremap = true })
vim.keymap.set('n', '<M-z>', '<C-w>z', { noremap = true })
vim.keymap.set('n', '<M-c>', '<C-w>c', { noremap = true }) -- Close current window
vim.keymap.set('n', '<M-o>', '<C-w>o', { noremap = true }) -- Close all other windows
vim.keymap.set('n', '<M-t>', '<C-w>t', { noremap = true })
vim.keymap.set('n', '<M-T>', '<C-w>T', { noremap = true })
vim.keymap.set('n', '<M-]>', '<C-w>]', { noremap = true })
vim.keymap.set('n', '<M-^>', '<C-w>^', { noremap = true })
vim.keymap.set('n', '<M-b>', '<C-w>b', { noremap = true })
vim.keymap.set('n', '<M-d>', '<C-w>d', { noremap = true })
vim.keymap.set('n', '<M-f>', '<C-w>f', { noremap = true })
vim.keymap.set('n', '<M-g><M-]>', '<C-w>g<C-]>', { noremap = true })
vim.keymap.set('n', '<M-g>]', '<C-w>g]', { noremap = true })
vim.keymap.set('n', '<M-g>}', '<C-w>g}', { noremap = true })
vim.keymap.set('n', '<M-g>f', '<C-w>gf', { noremap = true })
vim.keymap.set('n', '<M-g>F', '<C-w>gF', { noremap = true })
vim.keymap.set('n', '<M-g>t', '<C-w>gt', { noremap = true })
vim.keymap.set('n', '<M-g>T', '<C-w>gT', { noremap = true })
vim.keymap.set('n', '<M-g><Tab>', '<C-w>g<Tab>', { noremap = true })
vim.keymap.set('n', '<M-}>', '<C-w>}', { noremap = true })

-- Close all floating windows
vim.keymap.set('n', 'q',
  function()
    require('utils.funcs').close_all_floatings('q')
  end,
  { noremap = true }
)

-- Multi-buffer operations
vim.keymap.set('n', '<Tab>', '<cmd>bn<CR>', { noremap = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>bp<CR>', { noremap = true })
-- Delete current buffer
vim.keymap.set('n', '<M-C>', '<cmd>bd<CR>', { noremap = true })
-- <Tab> / <C-i> is used to switch buffers,
-- so use <C-n> to jump to newer cursor position instead
vim.keymap.set('n', '<C-n>', '<C-i>', { noremap = true })

-- Moving in insert and command-line mode
vim.keymap.set('!', '<M-h>', '<left>', { noremap = true })
vim.keymap.set('!', '<M-j>', '<down>', { noremap = true })
vim.keymap.set('!', '<M-k>', '<up>', { noremap = true })
vim.keymap.set('!', '<M-l>', '<right>', { noremap = true })
