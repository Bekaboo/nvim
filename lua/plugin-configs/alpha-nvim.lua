local M = {}

M.alpha = require('alpha')
M.dashboard = require('alpha.themes.dashboard')
M.headers = require('utils.shared').ascii_art

M.leader = '<LD>'

M.button = function(usr_opts, txt, leader_txt, keybind, keybind_opts)
  local sc_after = usr_opts.shortcut:gsub('%s', ''):gsub(leader_txt, '<leader>')

  local default_opts = {
    position = 'center',
    cursor = 5,
    width = 50,
    align_shortcut = 'right',
    hl_shortcut = 'Keyword'
  }
  local opts = vim.tbl_deep_extend('force', default_opts, usr_opts)

  if nil == keybind then
    keybind = sc_after
  end
  keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
  opts.keymap = { 'n', sc_after, keybind, keybind_opts }

  local function on_press()
    -- local key = vim.api.nvim_replace_termcodes(keybind .. '<Ignore>', true, false, true)
    local key = vim.api.nvim_replace_termcodes(sc_after .. '<Ignore>', true, false, true)
    vim.api.nvim_feedkeys(key, 't', false)
  end

  return {
    type = 'button',
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end

math.randomseed(os.time())
M.dashboard.section.header.val = M.headers[math.random(1, #M.headers)]

M.dashboard_button_opts = {
  { { shortcut = 'e', hl = { { 'IconColor1', 2, 3 } } }, 'ﱐ  New file', M.leader, '<cmd>ene<CR>' },
  { { shortcut = 's', hl = { { 'IconColor2', 2, 3 } } }, '  Sync plugins', M.leader, '<cmd>PackerSync<CR>' },
  { { shortcut = 'c', hl = { { 'IconColor3', 2, 3 } } }, '  Configurations', M.leader, '<cmd>Vifm ~/.config/nvim<CR>' },
  { { shortcut = 'g', hl = { { 'IconColor4', 2, 3 } } }, '  Git', M.leader, '<cmd>Git<CR>' },
  { { shortcut = M.leader .. ' f f', hl = { { 'IconColor5', 2, 3 } } }, '  Find files', M.leader, '<cmd>Telescope find_files<CR>' },
  { { shortcut = M.leader .. ' f j', hl = { { 'IconColor6', 2, 3 } } }, '﬘  Switch to project', M.leader, '<cmd>Telescope project display_type=full<CR>' },
  { { shortcut = M.leader .. ' f ;', hl = { { 'IconColor7', 2, 3 } } }, 'ﭨ  Live grep', M.leader, '<cmd>Telescope live_grep<CR>' },
  { { shortcut = 'Q', hl = { { 'IconColor8', 2, 3 } } }, '  Quit', M.leader, '<cmd>qa<CR>' },
}
M.dashboard.section.buttons.val = {}
for _, button in ipairs(M.dashboard_button_opts) do
  table.insert(M.dashboard.section.buttons.val, M.button(unpack(button)))
end

-- Footer must be a table so that its height is correctly measured
local num_plugins_loaded = #vim.fn.globpath(vim.fn.stdpath('data') .. '/site/pack/packer/start', '*', 0, 1)
local num_plugins_tot = #vim.tbl_keys(packer_plugins)
if num_plugins_tot <= 1 then
  M.dashboard.section.footer.val = { num_plugins_loaded .. ' / ' .. num_plugins_tot .. ' plugin ﮣ loaded' }
else
  M.dashboard.section.footer.val = { num_plugins_loaded .. ' / ' .. num_plugins_tot .. ' plugins ﮣ loaded' }
end
M.dashboard.section.footer.opts.hl = 'Comment'


-- Set paddings
local h_header = #M.dashboard.section.header.val
local h_buttons = #M.dashboard.section.buttons.val * 2 - 1
local h_footer = #M.dashboard.section.footer.val
local pad_tot = vim.o.lines - (h_header + h_buttons + h_footer)
local pad_1 = math.ceil(pad_tot * 0.25)
local pad_2 = math.ceil(pad_tot * 0.20)
local pad_3 = math.floor(pad_tot * 0.30)
M.dashboard.config.layout = {
  { type = 'padding', val = pad_1 },
  M.dashboard.section.header,
  { type = 'padding', val = pad_2 },
  M.dashboard.section.buttons,
  { type = 'padding', val = pad_3 },
  M.dashboard.section.footer
}

-- Do not show statusline or tabline in alpha buffer
vim.cmd [[ au User AlphaReady if winnr('$') == 1 | set laststatus=0 showtabline=0 | endif | au BufUnload <buffer> set laststatus=3 showtabline=2 ]]

M.alpha.setup(M.dashboard.opts)

return M
