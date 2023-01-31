local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt

opt.cmdheight      = 0
opt.cursorline     = true
opt.eb             = false
opt.foldlevelstart = 99
opt.guifont        = 'FiraCode Nerd Font:h12'
opt.laststatus     = 3
opt.mouse          = 'a'
opt.number         = true
opt.pumheight      = 16
opt.relativenumber = true
opt.ruler          = true
opt.scrolloff      = 4
opt.showtabline    = 0
opt.signcolumn     = 'auto'
opt.splitright     = true
opt.swapfile       = false
opt.termguicolors  = true
opt.undofile       = true
opt.updatetime     = 10
opt.vb             = true
opt.wrap           = false

-- Cursor shape
-- opt.gcr = 'n-v:block,i-c-ci-ve:blinkoff500-blinkon500-block,r-cr-o:hor20'
opt.gcr:append('n-v:block-Cursor/lCursor')
opt.gcr:append('i-c-ci-ve:blinkoff500-blinkon500-block-Cursor/lCursor')
opt.gcr:append('r-cr:hor20,o:hor50')

opt.backup    = true
opt.backupdir = fn.stdpath('data') .. '/backup//'

opt.list = true
opt.listchars = {
  tab        = '→ ',
  extends    = '…',
  precedes   = '…',
  nbsp       = '⌴',
  trail      = '·',
  lead       = '·',
  multispace = '·'
}
-- Extra settings to show spaces hiding in tabs
vim.fn.matchadd('NonText', [[\zs\ [ ]\@!\ze\t\+]], 0, -1, { conceal = '·' })
vim.fn.matchadd('NonText', [[\t\+\zs\ [ ]\@!]], 0, -1, { conceal = '·' })
opt.conceallevel = 2

opt.ts          = 4
opt.softtabstop = 4
opt.shiftwidth  = 4
opt.expandtab   = true
opt.smartindent = true
opt.autoindent  = true

opt.hlsearch    = false
opt.ignorecase  = true
opt.smartcase   = true

-- disable plugins shipped with neovim
g.loaded_gzip            = 1
g.loaded_tar             = 1
g.loaded_tarPlugin       = 1
g.loaded_zip             = 1
g.loaded_zipPlugin       = 1
g.loaded_getscript       = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball         = 1
g.loaded_vimballPlugin   = 1
g.loaded_matchit         = 1
g.loaded_2html_plugin    = 1
g.loaded_logiPat         = 1
g.loaded_rrhelper        = 1
g.loaded_netrw           = 1
g.loaded_netrwPlugin     = 1
g.loaded_netrwSettings   = 1

-- colorscheme
cmd('colorscheme nvim-falcon')

-- abbreviations
cmd('cnoreabbrev qa qa!')
cmd('cnoreabbrev bw bw!')
