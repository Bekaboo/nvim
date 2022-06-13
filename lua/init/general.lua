vim.o.eb = false
vim.o.vb = true
vim.o.relativenumber = true
vim.o.number = true
vim.o.ruler = true
vim.o.scrolloff = 8
vim.o.wrap = false
vim.o.termguicolors = true
vim.o.pumheight = 16
vim.o.cursorline = true
vim.o.cursorlineopt = 'both'
vim.o.cursorcolumn = true
vim.o.undofile = true
vim.o.mouse = 'a'
vim.o.laststatus = 3          -- Global status line, for neovim >= 0.7.0
vim.o.foldlevelstart = 99     -- Always start editing with no fold closed
vim.o.signcolumn = 'auto:1-2' -- For gitgutter & LSP diagnostic
vim.o.updatetime = 10         -- (ms)
vim.o.swapfile = false
vim.g.colorscheme = 'dracula' -- Default colorscheme

vim.opt.list = true
vim.opt.listchars = {
  tab = '──•',
  extends = '►',
  precedes = '◄',
  nbsp = '⌴',
  trail = '·',
  lead = '·',
  multispace = '·'
}
-- Extra settings to show spaces hiding in tabs
vim.fn.matchadd('Conceal', [[\zs\ [ ]\@!\ze\t\+]], 0, -1, { conceal = '·' })
vim.fn.matchadd('Conceal', [[\t\+\zs\ [ ]\@!]], 0, -1, { conceal = '·' })
vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nic'

vim.o.ts = 4
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true

vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.spell = true
vim.o.spelllang = 'en,cjk'
vim.o.spellsuggest = 'best, 9'
vim.o.spellcapcheck = ''
vim.o.spelloptions = 'camel'
