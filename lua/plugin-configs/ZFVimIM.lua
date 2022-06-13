local M = {}

-- Remote pinyin base setup
vim.g.ZFVimIM_pinyin_gitUserEmail = require('utils.git_account').email
vim.g.ZFVimIM_pinyin_gitUserName = require('utils.git_account').name
vim.g.ZFVimIM_pinyin_gitUserToken = require('utils.git_account').token
vim.g.ZFVimIM_autoAddWordLen = 3 * 12

M.ZFVimIM_Set_cmdEdit = function()
  local cmdtype = vim.fn.getcmdtype()
  if cmdtype ~= ':' and cmdtype ~= '/' and cmdtype ~= '?' then
    return
  end
  local keyseq = ''
  -- If is not called from a search in cmd window,
  -- set the keyseq to open the cnd window for editing
  if vim.fn.bufexists('[Command Line]') == 0 then
    keyseq = '<C-c>q' .. cmdtype .. 'i'
    if vim.fn.getcmdpos() > 1 then
      keyseq = keyseq .. '<BS>'
    end
  end
  -- WORKAROUND: if this function is called the first time when ZFVimIM
  -- has not been activated before then there will be extra double quotes
  -- at the end of the current cmdline *(only happens in neovim)
  if not vim.g.ZFVimIM_called_Before then
    keyseq = keyseq .. '<BS><BS>'
  else
    keyseq = keyseq .. '<Space><BS>'
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keyseq, true, true, true), 'nt', true)
  -- If is not called from a search in cmd window, launch ZFVimIME
  if vim.fn.bufexists('[Command Line]') == 0 then
    vim.fn.ZFVimIME_start()
  end
  return ''
end

M.ZF_Save_Status = function(key)
  vim.g.ZFVimIM_Status_Save = vim.fn.ZFVimIME_started and vim.fn.ZFVimIME_started()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), 'nt', true)
end

M.ZF_Restore_Status = function()
  if not vim.g.ZFVimIM_Status_Save or vim.g.ZFVimIM_Status_Save == 0 then
    vim.fn.ZFVimIME_stop()
  else
    vim.fn.ZFVimIME_start()
  end
end

vim.keymap.set('c', '<C-Space>', M.ZFVimIM_Set_cmdEdit, { noremap = true, silent = true })
vim.keymap.set('i', '<C-Space>', vim.fn.ZFVimIME_keymap_toggle_i, { noremap = true, silent = true })
vim.keymap.set('n', '<C-Space>', vim.fn.ZFVimIME_keymap_toggle_n, { noremap = true, silent = true })
vim.keymap.set('v', '<C-Space>', vim.fn.ZFVimIME_keymap_toggle_v, { noremap = true, silent = true })

-- Save ZFVimIM status (ON / OFF) before entering the cmdline
-- or the cmd window, so that we can recover it after we leave
-- the cmd window
-- ZFVimIM status in normal window persists in cmd window,
-- but the status in the cmd window should not affect
-- the status in normal windows
vim.keymap.set('n', 'q:', function() M.ZF_Save_Status('q:') end, { noremap = true, silent = true })
vim.keymap.set('n', 'q?', function() M.ZF_Save_Status('q?') end, { noremap = true, silent = true })
vim.keymap.set('n', 'q/', function() M.ZF_Save_Status('q/') end, { noremap = true, silent = true })
vim.keymap.set('n', ':', function() M.ZF_Save_Status(':') end, { noremap = true, silent = true })
vim.keymap.set('n', '?', function() M.ZF_Save_Status('?') end, { noremap = true, silent = true })
vim.keymap.set('n', '/', function() M.ZF_Save_Status('/') end, { noremap = true, silent = true })

vim.api.nvim_create_augroup('ZFVimIM_Status_Management', { clear = true })
vim.api.nvim_create_autocmd('CmdwinLeave', {
  pattern = '*',
  callback = M.ZF_Restore_Status,
  group = 'ZFVimIM_Status_Management',
})
vim.api.nvim_create_autocmd('User', {
  pattern = 'ZFVimIME_event_OnStart',
  callback = function() vim.g.ZFVimIM_called_Before = true end,
  group = 'ZFVimIM_Status_Management',
})

-- Statusline integration
if require('utils.funcs').loaded('lualine.nvim') then
  local lualine_cfg = require('plugin-configs.lualine')
  local lualine = lualine_cfg.lualine
  local lualine_opts = lualine_cfg.opts
  table.insert(lualine_opts.sections.lualine_a, function()
    return vim.fn['ZFVimIME_IMEStatusline']()
  end
  )
  lualine.setup(lualine_opts)
else
  vim.o.statusline = vim.o.statusline .. '%ZFVimIME_IMEStatusline()'
end

return M
