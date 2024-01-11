local map = vim.api.nvim_set_keymap

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

map('n', '<Space>', '<Nop>', { noremap = true })
map('x', '<Space>', '<Nop>', { noremap = true })

-- Multi-window operations
-- stylua: ignore start
map('n', '<M-W>',      '<C-w>W',      { noremap = true })
map('n', '<M-H>',      '<C-w>H',      { noremap = true })
map('n', '<M-J>',      '<C-w>J',      { noremap = true })
map('n', '<M-K>',      '<C-w>K',      { noremap = true })
map('n', '<M-L>',      '<C-w>L',      { noremap = true })
map('n', '<M-=>',      '<C-w>=',      { noremap = true })
map('n', '<M-_>',      '<C-w>_',      { noremap = true })
map('n', '<M-|>',      '<C-w>|',      { noremap = true })
map('n', '<M-p>',      '<C-w>p',      { noremap = true })
map('n', '<M-r>',      '<C-w>r',      { noremap = true })
map('n', '<M-v>',      '<C-w>v',      { noremap = true })
map('n', '<M-s>',      '<C-w>s',      { noremap = true })
map('n', '<M-x>',      '<C-w>x',      { noremap = true })
map('n', '<M-z>',      '<C-w>z',      { noremap = true })
map('n', '<M-c>',      '<C-w>c',      { noremap = true })
map('n', '<M-n>',      '<C-w>n',      { noremap = true })
map('n', '<M-o>',      '<C-w>o',      { noremap = true })
map('n', '<M-t>',      '<C-w>t',      { noremap = true })
map('n', '<M-T>',      '<C-w>T',      { noremap = true })
map('n', '<M-]>',      '<C-w>]',      { noremap = true })
map('n', '<M-^>',      '<C-w>^',      { noremap = true })
map('n', '<M-b>',      '<C-w>b',      { noremap = true })
map('n', '<M-d>',      '<C-w>d',      { noremap = true })
map('n', '<M-f>',      '<C-w>f',      { noremap = true })
map('n', '<M-}>',      '<C-w>}',      { noremap = true })
map('n', '<M-g>]',     '<C-w>g]',     { noremap = true })
map('n', '<M-g>}',     '<C-w>g}',     { noremap = true })
map('n', '<M-g>f',     '<C-w>gf',     { noremap = true })
map('n', '<M-g>F',     '<C-w>gF',     { noremap = true })
map('n', '<M-g>t',     '<C-w>gt',     { noremap = true })
map('n', '<M-g>T',     '<C-w>gT',     { noremap = true })
map('n', '<M-w>',      '<C-w><C-w>',  { noremap = true })
map('n', '<M-h>',      '<C-w><C-h>',  { noremap = true })
map('n', '<M-j>',      '<C-w><C-j>',  { noremap = true })
map('n', '<M-k>',      '<C-w><C-k>',  { noremap = true })
map('n', '<M-l>',      '<C-w><C-l>',  { noremap = true })
map('n', '<M-g><M-]>', '<C-w>g<C-]>', { noremap = true })
map('n', '<M-g><Tab>', '<C-w>g<Tab>', { noremap = true })
map('n', '<M-+>',      'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true, noremap = true })
map('n', '<M-->',      'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true, noremap = true })
map('n', '<M->>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true, noremap = true })
map('n', '<M-<>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true, noremap = true })
map('n', '<M-.>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true, noremap = true })
map('n', '<M-,>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true, noremap = true })

map('n', '<C-w>+', 'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true, noremap = true })
map('n', '<C-w>-', 'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true, noremap = true })
map('n', '<C-w>>', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true, noremap = true })
map('n', '<C-w><', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true, noremap = true })
map('n', '<C-w>,', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true, noremap = true })
map('n', '<C-w>.', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true, noremap = true })

map('x', '<M-W>',      '<C-w>W',      { noremap = true })
map('x', '<M-H>',      '<C-w>H',      { noremap = true })
map('x', '<M-J>',      '<C-w>J',      { noremap = true })
map('x', '<M-K>',      '<C-w>K',      { noremap = true })
map('x', '<M-L>',      '<C-w>L',      { noremap = true })
map('x', '<M-=>',      '<C-w>=',      { noremap = true })
map('x', '<M-_>',      '<C-w>_',      { noremap = true })
map('x', '<M-|>',      '<C-w>|',      { noremap = true })
map('x', '<M-p>',      '<C-w>p',      { noremap = true })
map('x', '<M-r>',      '<C-w>r',      { noremap = true })
map('x', '<M-v>',      '<C-w>v',      { noremap = true })
map('x', '<M-s>',      '<C-w>s',      { noremap = true })
map('x', '<M-x>',      '<C-w>x',      { noremap = true })
map('x', '<M-z>',      '<C-w>z',      { noremap = true })
map('x', '<M-c>',      '<C-w>c',      { noremap = true })
map('x', '<M-n>',      '<C-w>n',      { noremap = true })
map('x', '<M-o>',      '<C-w>o',      { noremap = true })
map('x', '<M-t>',      '<C-w>t',      { noremap = true })
map('x', '<M-T>',      '<C-w>T',      { noremap = true })
map('x', '<M-]>',      '<C-w>]',      { noremap = true })
map('x', '<M-^>',      '<C-w>^',      { noremap = true })
map('x', '<M-b>',      '<C-w>b',      { noremap = true })
map('x', '<M-d>',      '<C-w>d',      { noremap = true })
map('x', '<M-f>',      '<C-w>f',      { noremap = true })
map('x', '<M-}>',      '<C-w>}',      { noremap = true })
map('x', '<M-g>]',     '<C-w>g]',     { noremap = true })
map('x', '<M-g>}',     '<C-w>g}',     { noremap = true })
map('x', '<M-g>f',     '<C-w>gf',     { noremap = true })
map('x', '<M-g>F',     '<C-w>gF',     { noremap = true })
map('x', '<M-g>t',     '<C-w>gt',     { noremap = true })
map('x', '<M-g>T',     '<C-w>gT',     { noremap = true })
map('x', '<M-w>',      '<C-w><C-w>',  { noremap = true })
map('x', '<M-h>',      '<C-w><C-h>',  { noremap = true })
map('x', '<M-j>',      '<C-w><C-j>',  { noremap = true })
map('x', '<M-k>',      '<C-w><C-k>',  { noremap = true })
map('x', '<M-l>',      '<C-w><C-l>',  { noremap = true })
map('x', '<M-g><M-]>', '<C-w>g<C-]>', { noremap = true })
map('x', '<M-g><Tab>', '<C-w>g<Tab>', { noremap = true })
map('x', '<M-+>',      'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true, noremap = true })
map('x', '<M-->',      'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true, noremap = true })
map('x', '<M->>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true, noremap = true })
map('x', '<M-<>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true, noremap = true })
map('x', '<M-.>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true, noremap = true })
map('x', '<M-,>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true, noremap = true })

map('x', '<C-w>+', 'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true, noremap = true })
map('x', '<C-w>-', 'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true, noremap = true })
map('x', '<C-w>>', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true, noremap = true })
map('x', '<C-w><', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true, noremap = true })
map('x', '<C-w>,', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true, noremap = true })
map('x', '<C-w>.', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true, noremap = true })
-- stylua: ignore end

-- Terminal mode keymaps
-- stylua: ignore start
map('t', '<C-6>', '<Cmd>b#<CR>',        { noremap = true })
map('t', '<C-^>', '<Cmd>b#<CR>',        { noremap = true })
map('t', '<M-v>', '<Cmd>wincmd v<CR>',  { noremap = true })
map('t', '<M-s>', '<Cmd>wincmd s<CR>',  { noremap = true })
map('t', '<M-W>', '<Cmd>wincmd W<CR>',  { noremap = true })
map('t', '<M-H>', '<Cmd>wincmd H<CR>',  { noremap = true })
map('t', '<M-J>', '<Cmd>wincmd J<CR>',  { noremap = true })
map('t', '<M-K>', '<Cmd>wincmd K<CR>',  { noremap = true })
map('t', '<M-L>', '<Cmd>wincmd L<CR>',  { noremap = true })
map('t', '<M-=>', '<Cmd>wincmd =<CR>',  { noremap = true })
map('t', '<M-_>', '<Cmd>wincmd _<CR>',  { noremap = true })
map('t', '<M-|>', '<Cmd>wincmd |<CR>',  { noremap = true })
map('t', '<M-+>', '<Cmd>wincmd 2+<CR>', { noremap = true })
map('t', '<M-->', '<Cmd>wincmd 2-<CR>', { noremap = true })
map('t', '<M-r>', '<Cmd>wincmd r<CR>',  { noremap = true })
map('t', '<M-R>', '<Cmd>wincmd R<CR>',  { noremap = true })
map('t', '<M-x>', '<Cmd>wincmd x<CR>',  { noremap = true })
map('t', '<M-p>', '<Cmd>wincmd p<CR>',  { noremap = true })
map('t', '<M-c>', '<Cmd>wincmd c<CR>',  { noremap = true })
map('t', '<M-o>', '<Cmd>wincmd o<CR>',  { noremap = true })
map('t', '<M-w>', '<Cmd>wincmd w<CR>',  { noremap = true })
map('t', '<M-h>', '<Cmd>wincmd h<CR>',  { noremap = true })
map('t', '<M-j>', '<Cmd>wincmd j<CR>',  { noremap = true })
map('t', '<M-k>', '<Cmd>wincmd k<CR>',  { noremap = true })
map('t', '<M-l>', '<Cmd>wincmd l<CR>',  { noremap = true })
map('t', '<M->>', '"<Cmd>wincmd 4" . (winnr() == winnr("l") ? "<" : ">") . "<CR>"', { expr = true, noremap = true })
map('t', '<M-<>', '"<Cmd>wincmd 4" . (winnr() == winnr("l") ? ">" : "<") . "<CR>"', { expr = true, noremap = true })
map('t', '<M-.>', '"<Cmd>wincmd 4" . (winnr() == winnr("l") ? "<" : ">") . "<CR>"', { expr = true, noremap = true })
map('t', '<M-,>', '"<Cmd>wincmd 4" . (winnr() == winnr("l") ? ">" : "<") . "<CR>"', { expr = true, noremap = true })
-- stylua: ignore end

-- Use <C-\><C-r> to insert contents of a register in terminal mode
map(
  't',
  [[<C-\><C-r>]],
  [['<C-\><C-n>"' . nr2char(getchar()) . 'pi']],
  { expr = true, noremap = true }
)

-- More consistent behavior when &wrap is set
-- stylua: ignore start
map('n', 'j', 'v:count ? "j" : "gj"', { expr = true, noremap = true })
map('n', 'k', 'v:count ? "k" : "gk"', { expr = true, noremap = true })
map('x', 'j', 'v:count ? "j" : "gj"', { expr = true, noremap = true })
map('x', 'k', 'v:count ? "k" : "gk"', { expr = true, noremap = true })
map('n', '<Down>', 'v:count ? "<Down>" : "g<Down>"', { expr = true, replace_keycodes = false, noremap = true })
map('n', '<Up>',   'v:count ? "<Up>"   : "g<Up>"',   { expr = true, replace_keycodes = false, noremap = true })
map('x', '<Down>', 'v:count ? "<Down>" : "g<Down>"', { expr = true, replace_keycodes = false, noremap = true })
map('x', '<Up>',   'v:count ? "<Up>"   : "g<Up>"',   { expr = true, replace_keycodes = false, noremap = true })
map('i', '<Down>', '<Cmd>norm! g<Down><CR>', { noremap = true })
map('i', '<Up>',   '<Cmd>norm! g<Up><CR>',   { noremap = true })
-- stylua: ignore end

-- Buffer navigation
map('n', ']b', '<Cmd>exec v:count1 . "bn"<CR>', { noremap = true })
map('n', '[b', '<Cmd>exec v:count1 . "bp"<CR>', { noremap = true })

-- Tabpages
---@param tab_action function
---@param default_count number?
---@return function
local function tabswitch(tab_action, default_count)
  return function()
    local count = default_count or vim.v.count
    local num_tabs = vim.fn.tabpagenr('$')
    if num_tabs >= count then
      tab_action(count ~= 0 and count or nil)
      return
    end
    vim.cmd.tablast()
    for _ = 1, count - num_tabs do
      vim.cmd.tabnew()
    end
  end
end

-- stylua: ignore start
map('n', 'gt', '<Nop>', { callback = tabswitch(vim.cmd.tabnext), noremap = true })
map('n', 'gT', '<Nop>', { callback = tabswitch(vim.cmd.tabprev), noremap = true })
map('n', 'gy', '<Nop>', { callback = tabswitch(vim.cmd.tabprev), noremap = true }) -- gT is too hard to press

map('n', '<Leader>0', '<Cmd>0tabnew<CR>', { noremap = true })
map('n', '<Leader>1', '<Nop>', { callback = tabswitch(vim.cmd.tabnext, 1),  noremap = true })
map('n', '<Leader>2', '<Nop>', { callback = tabswitch(vim.cmd.tabnext, 2),  noremap = true })
map('n', '<Leader>3', '<Nop>', { callback = tabswitch(vim.cmd.tabnext, 3),  noremap = true })
map('n', '<Leader>4', '<Nop>', { callback = tabswitch(vim.cmd.tabnext, 4),  noremap = true })
map('n', '<Leader>5', '<Nop>', { callback = tabswitch(vim.cmd.tabnext, 5),  noremap = true })
map('n', '<Leader>6', '<Nop>', { callback = tabswitch(vim.cmd.tabnext, 6),  noremap = true })
map('n', '<Leader>7', '<Nop>', { callback = tabswitch(vim.cmd.tabnext, 7),  noremap = true })
map('n', '<Leader>8', '<Nop>', { callback = tabswitch(vim.cmd.tabnext, 8),  noremap = true })
map('n', '<Leader>9', '<Nop>', { callback = tabswitch(vim.cmd.tabnext, 9),  noremap = true })
-- stylua: ignore end

-- Complete line
map('i', '<C-l>', '<C-x><C-l>', { noremap = true })

-- Correct misspelled word / mark as correct
map('i', '<C-g>+', '<Esc>[szg`]a', { noremap = true })
map('i', '<C-g>=', '<C-g>u<Esc>[s1z=`]a<C-G>u', { noremap = true })

-- Only clear highlights and message area and don't redraw if search
-- highlighting is on to avoid flickering
---@return nil
local function _ctrl_l()
  return '<Cmd>nohlsearch|diffupdate|echo<CR>'
    .. (vim.v.hlsearch == 0 and '<C-l>' or '')
end
-- stylua: ignore start
map('n', '<C-l>', '<Nop>', { callback = _ctrl_l, expr = true, replace_keycodes = true, noremap = true })
map('t', '<C-l>', '<Nop>', { callback = _ctrl_l, expr = true, replace_keycodes = true, noremap = true })
-- stylua: ignore end

-- Don't include extra spaces around quotes
map('o', 'a"', '2i"', {})
map('o', "a'", "2i'", {})
map('o', 'a`', '2i`', {})
map('x', 'a"', '2i"', {})
map('x', "a'", "2i'", {})
map('x', 'a`', '2i`', {})

-- Close all floating windows
map('n', 'q', '<Nop>', {
  callback = function()
    require('utils.misc').q()
  end,
  noremap = true,
})

-- Text object: current buffer
-- stylua: ignore start
map('x', 'af', ':<C-u>silent! keepjumps normal! ggVG<CR>', { silent = true, noremap = false })
map('x', 'if', ':<C-u>silent! keepjumps normal! ggVG<CR>', { silent = true, noremap = false })
map('o', 'af', '<Cmd>silent! normal m`Vaf<CR><Cmd>silent! normal! ``<CR>', { silent = true, noremap = false })
map('o', 'if', '<Cmd>silent! normal m`Vif<CR><Cmd>silent! normal! ``<CR>', { silent = true, noremap = false })
-- stylua: ignore end

-- stylua: ignore start
map('x', 'iz', [[':<C-u>silent! keepjumps normal! ' . v:lua.require'utils.misc'.textobj_fold('i') . '<CR>']], { silent = true, expr = true, noremap = false })
map('x', 'az', [[':<C-u>silent! keepjumps normal! ' . v:lua.require'utils.misc'.textobj_fold('a') . '<CR>']], { silent = true, expr = true, noremap = false })
map('o', 'iz', '<Cmd>silent! normal Viz<CR>', { silent = true, noremap = false })
map('o', 'az', '<Cmd>silent! normal Vaz<CR>', { silent = true, noremap = false })
-- stylua: ignore end

-- Use 'g{' and 'g}' to move to the first/last line of a paragraph
---@return nil
local function _pfirst()
  require('utils.misc').goto_paragraph_firstline()
end
---@return nil
local function _plast()
  require('utils.misc').goto_paragraph_lastline()
end
map('n', 'g}', '<Nop>', { callback = _plast, noremap = false })
map('x', 'g}', '<Nop>', { callback = _plast, noremap = false })
map('n', 'g{', '<Nop>', { callback = _pfirst, noremap = false })
map('x', 'g{', '<Nop>', { callback = _pfirst, noremap = false })
map('o', 'g}', '<Cmd>silent! normal Vg}<CR>', { noremap = false })
map('o', 'g{', '<Cmd>silent! normal Vg{<CR>', { noremap = false })

-- Abbreviations
map('!a', 'ture', 'true', { noremap = true })
map('!a', 'Ture', 'True', { noremap = true })
map('!a', 'flase', 'false', { noremap = true })
map('!a', 'fasle', 'false', { noremap = true })
map('!a', 'Flase', 'False', { noremap = true })
map('!a', 'Fasle', 'False', { noremap = true })
map('!a', 'lcaol', 'local', { noremap = true })
map('!a', 'lcoal', 'local', { noremap = true })
map('!a', 'locla', 'local', { noremap = true })
map('!a', 'sahre', 'share', { noremap = true })
map('!a', 'saher', 'share', { noremap = true })
map('!a', 'balme', 'blame', { noremap = true })

vim.api.nvim_create_autocmd('CmdlineEnter', {
  once = true,
  callback = function()
    local utils = require('utils')
    utils.keymap.command_map('S', '%s/')
    utils.keymap.command_map(':', 'lua ')
    utils.keymap.command_abbrev('man', 'Man')
    utils.keymap.command_abbrev('bt', 'bel te')
    utils.keymap.command_abbrev('ep', 'e%:p:h')
    utils.keymap.command_abbrev('vep', 'vs%:p:h')
    utils.keymap.command_abbrev('sep', 'sp%:p:h')
    utils.keymap.command_abbrev('tep', 'tabe%:p:h')
    utils.keymap.command_abbrev('rm', '!rm')
    utils.keymap.command_abbrev('mv', '!mv')
    utils.keymap.command_abbrev('git', '!git')
    utils.keymap.command_abbrev('mkd', '!mkdir')
    utils.keymap.command_abbrev('mkdir', '!mkdir')
    utils.keymap.command_abbrev('touch', '!touch')
    return true
  end,
})
