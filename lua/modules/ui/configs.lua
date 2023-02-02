local M = {}

M['barbar.nvim'] = function()
  require('bufferline').setup({
    auto_hide = true,
    tabpages = true,
    closable = true,
    clickable = true,
    icons = 'both',
    icon_custom_colors = false,
    icon_separator_active = '',
    icon_separator_inactive = '',
    icon_close_tab = '',
    icon_close_tab_modified = '[+]',
    icon_pinned = '',
    insert_at_end = false,
    insert_at_start = false,
    maximum_padding = 1,
    maximum_length = 30,
    semantic_letters = true,
    letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
    no_name_title = nil
  })

  local barbar_api = require('bufferline.api')
  local function nnoremap(lhs, rhs)
    vim.keymap.set('n', lhs, rhs, { noremap = true, silent = true })
  end
  nnoremap('<Tab>', function() barbar_api.goto_buffer_relative(1) end)
  nnoremap('<S-Tab>', function() barbar_api.goto_buffer_relative(-1) end)
  nnoremap('<M-.>', function() barbar_api.move_current_buffer(1) end)
  nnoremap('<M-,>', function() barbar_api.move_current_buffer(-1) end)
  for buf_number = 1, 9 do
    -- goto buffer in position 1..9
    nnoremap(string.format('<M-%d>', buf_number),
            function() barbar_api.goto_buffer(buf_number) end)
  end
  nnoremap('<M-0>', function() barbar_api.goto_buffer(-1) end)
  nnoremap('<M-(>', barbar_api.close_buffers_left)
  nnoremap('<M-)>', barbar_api.close_buffers_right)
  nnoremap('<M-P>', barbar_api.toggle_pin)
  nnoremap('<M-O>', barbar_api.close_all_but_visible)
  nnoremap('<M-C>', '<CMD>BufferClose<CR>') -- equivalent to :bufdo bwipeout
end

M['lualine.nvim'] = function()
  local function lualine_config()
    local function location()
      local cursor_loc = vim.api.nvim_win_get_cursor(0)
      return cursor_loc[1] .. ',' .. cursor_loc[2] + 1
    end

    local function indent_style()
      -- Get softtabstop or equivalent fallback
      local sts
      if vim.bo.sts > 0 then
        sts = vim.bo.sts
      elseif vim.bo.sw > 0 then
        sts = vim.bo.sw
      else
        sts = vim.bo.ts
      end

      if vim.bo.expandtab then
        return '• ' .. sts
      elseif vim.bo.ts == sts then
        return '⟼ ' .. vim.bo.tabstop
      else
        return '⟼ ' .. vim.bo.tabstop .. ' • ' .. sts
      end
    end

    local function searchcount()
      local info = vim.fn.searchcount({ maxcount = 999 })
      if not vim.o.hlsearch then
        return ''
      end
      if info.incomplete == 1 then  -- timed out
        return '[?/??]'
      end
      if info.total == 0 then
        return ''
      end
      if info.current > info.maxcount then
        info.current = '>' .. info.maxcount
      end
      if info.total > info.maxcount then
        info.total = '>' .. info.maxcount
      end
      return string.format('[%s/%s]', info.current, info.total)
    end

    local utils = require('colors.nvim-falcon.utils')
    local palette = utils.reload('colors.nvim-falcon.palette')

    local function lsp_icon()
      if #vim.lsp.get_active_clients({
        bufnr = vim.api.nvim_get_current_buf()
      }) > 0 then
        return ' '
      end
      return ''
    end

    local function lsp_list()
      local lsp_names = vim.tbl_map(function(client_info)
        return client_info.name
      end, vim.lsp.get_active_clients({
        bufnr = vim.api.nvim_get_current_buf()
      }))

      if #lsp_names == 0 then
        return ''
      else
        return table.concat(lsp_names, ', ')
      end
    end

    local function reg_recording()
      local reg = vim.fn.reg_recording()
      if vim.fn.empty(reg) == 0 then
        return 'recording @' .. reg
      end
      return ''
    end

    local function longer_than(len)
      return function()
        return vim.o.columns > len
      end
    end

    local function shorter_than(len)
      return function()
        return vim.o.columns <= len
      end
    end

    require('lualine').setup({
      options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        globalstatus = vim.o.laststatus == 3,
        theme = 'nvim-falcon',
      },
      extensions = { 'aerial' },
      sections = {
        lualine_a = {
          'mode',
          {
            reg_recording,
            color = { fg = palette.space, bg = palette.orange, gui = 'bold' },
            cond = function() return vim.o.cmdheight == 0 end,
          },
        },
        lualine_b = {
          { 'branch', icon = { '', color = { fg = palette.turquoise } } },
          { 'diff', cond = longer_than(50), padding = { left = 0, right = 1 } },
          { 'diagnostics', cond = longer_than(50) },
        },
        lualine_c = {
          {
            'filetype',
            icon_only = true,
            padding = { left = 1, right = 0 },
          },
          {
            'filename',
            path = 1,
            symbols = {
              modified = '[+]',
              readonly = '[-]',
              unnamed = '',
            },
            cond = longer_than(115),
          },
          {
            'filename',
            symbols = {
              modified = '[+]',
              readonly = '[-]',
              unnamed = '',
            },
            cond = shorter_than(115),
          },
        },
        lualine_x = {
          { indent_style, cond = longer_than(60) },
          { 'encoding', cond = longer_than(85) },
          {
            'fileformat',
            symbols = {
              unix = 'Unix',
              dos = 'DOS',
              mac = 'Mac',
            },
            cond = longer_than(70),
          },
          {
            lsp_icon,
            cond = longer_than(70),
            color = { fg = palette.lavender }
          },
          {
            lsp_list,
            cond = longer_than(105),
            padding = { left = 0, right = 1 }
          },
        },
        lualine_y = {
          {
            searchcount,
            padding = { left = 1, right = 0 },
            cond = function() return vim.o.cmdheight == 0 end,
          },
          location
        },
        lualine_z = { 'progress' },
      },
    })
  end
  lualine_config()

  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = lualine_config,
  })
end

M['alpha-nvim'] = function()
  local alpha = require('alpha')
  local dashboard = require('alpha.themes.dashboard')
  local headers = require('utils.static').ascii_art

  local function make_button(usr_opts, txt, keybind, keybind_opts)
    local sc_after = usr_opts.shortcut:gsub('%s', '')
    local default_opts = {
      position = 'center',
      cursor = 5,
      width = 50,
      align_shortcut = 'right',
      hl_shortcut = 'Lavender'
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
  dashboard.section.header.val = headers[math.random(1, #headers)]
  dashboard.section.header.opts.hl = 'White'

  local dashboard_button_opts = {
    { { shortcut = 'e', hl = { { 'Tea', 2, 3 } } }, 'ﱐ  New file', '<cmd>ene<CR>' },
    { { shortcut = 's', hl = { { 'Pigeon', 2, 3 } } }, '  Sync plugins', '<cmd>PackerSync<CR>' },
    { { shortcut = 'c', hl = { { 'Turquoise', 2, 3 } } }, '  Open Config Files', '<cmd>e ' .. vim.fn.stdpath('config') .. '<CR>' },
    { { shortcut = 'i', hl = { { 'Ochre', 2, 3 } } }, '  Git', '<cmd>ToggleTool lazygit<CR>' },
    { { shortcut = 'f f', hl = { { 'Flashlight', 2, 3 } } }, '  Find files', '<cmd>Telescope find_files<CR>' },
    { { shortcut = 'f o', hl = { { 'Smoke', 2, 3 } } }, '  Old files', '<cmd>Telescope oldfiles<CR>' },
    { { shortcut = 'f m', hl = { { 'Earth', 2, 3 } } }, '  Goto bookmark', '<cmd>Telescope marks<CR>' },
    { { shortcut = 'f ;', hl = { { 'White', 2, 3 } } }, '  Live grep', '<cmd>Telescope live_grep<CR>' },
    { { shortcut = 'q', hl = { { 'Wine', 2, 3 } } }, '  Quit', '<cmd>qa<CR>' },
  }
  dashboard.section.buttons.val = {}
  for _, button in ipairs(dashboard_button_opts) do
    table.insert(dashboard.section.buttons.val, make_button(unpack(button)))
  end

  local function get_num_plugins_loaded()
    local num = 0
    for _, plugin in pairs(packer_plugins) do
      if plugin.loaded then
        num = num + 1
      end
    end
    return num
  end

  -- Footer must be a table so that its height is correctly measured
  local num_plugins_loaded = get_num_plugins_loaded()
  local num_plugins_tot = #vim.tbl_keys(packer_plugins)
  dashboard.section.footer.val = { string.format('%d / %d  plugins ﮣ loaded',
                                  num_plugins_loaded, num_plugins_tot) }
  dashboard.section.footer.opts.hl = 'Comment'

  -- Set paddings
  local h_header = #dashboard.section.header.val
  local h_buttons = #dashboard.section.buttons.val * 2 - 1
  local h_footer = #dashboard.section.footer.val
  local pad_tot = vim.o.lines - (h_header + h_buttons + h_footer)
  local pad_1 = math.ceil(pad_tot * 0.25)
  local pad_2 = math.ceil(pad_tot * 0.20)
  local pad_3 = math.floor(pad_tot * 0.20)
  dashboard.config.layout = {
    { type = 'padding', val = pad_1 },
    dashboard.section.header,
    { type = 'padding', val = pad_2 },
    dashboard.section.buttons,
    { type = 'padding', val = pad_3 },
    dashboard.section.footer
  }

  alpha.setup(dashboard.opts)

  -- Do not show statusline or tabline in alpha buffer
  vim.api.nvim_create_augroup('AlphaSetLine', {})
  vim.api.nvim_create_autocmd('User', {
    pattern = 'AlphaReady',
    callback = function()
      if vim.fn.winnr('$') == 1 then
        vim.t.laststatus_save = vim.o.laststatus
        vim.t.showtabline_save = vim.o.showtabline
        vim.o.laststatus = 0
        vim.o.showtabline = 0
      end
    end,
    group = 'AlphaSetLine',
  })
  vim.api.nvim_create_autocmd('BufUnload', {
    pattern = '*',
    callback = function()
      if vim.bo.ft == 'alpha' then
        vim.o.laststatus = vim.t.laststatus_save
        vim.o.showtabline = vim.t.showtabline_save
      end
    end,
    group = 'AlphaSetLine',
  })
end

M['nvim-navic'] = function()
  local navic = require('nvim-navic')
  local displen = vim.fn.strdisplaywidth
  navic.setup({
    icons = vim.tbl_map(function(icon)
      return vim.trim(icon)
    end, require('utils.static').icons),
    highlight = true,
    separator = ' ► ',
    safe_output = true
  })

  local function hl(str, hlgroup)
    if not hlgroup or hlgroup:match('^%s*$') then
      return str
    end
    return string.format('%%#%s#%s%%*', hlgroup, str or '')
  end

  local function concat(tbl, padding, tbl_hl, padding_hl)
    if vim.fn.empty(tbl) == 1 then return '' end
    if not padding then padding = ' ' end
    if not tbl_hl then tbl_hl = {} end
    if not tbl_hl then tbl_hl = {} end
    local result = nil
    for i, str in ipairs(tbl) do
      -- Do not concat if str is empty or
      -- contains only white spaces
      if not str:match('^%s*$') then
        result = result and result .. hl(padding, padding_hl) .. vim.trim(hl(str, tbl_hl[i]))
          or vim.trim(hl(str, tbl_hl[i]))
      end
    end
    return vim.trim(result or '')
  end

  local function get_dir_list()
    if vim.fn.bufname('%') == '' then
      return {}
    end

    local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
    local dir_list = vim.split(vim.fn.expand('%:~:.:h'), sep)
    if #dir_list == 0 or #dir_list == 1 and dir_list[1] == '.' then
      return {}
    end

    return vim.tbl_map(function(dir_name)
      return { name = dir_name }
    end, dir_list)
  end

  local function get_file()
    if vim.fn.bufname('%') == '' then
      return {}
    end

    local fname = vim.fn.expand('%:t')
    local icon, _ = require('nvim-web-devicons').get_icon(fname,
      vim.fn.fnamemodify(fname, ':e'), { default = true })
    return {
      icon = icon,
      name = fname,
    }
  end

  local function get_node_list()
    return vim.tbl_map(function(node)
      return {
        icon = node.icon,
        name = node.name,
        type = node.type,
      }
    end, navic.get_data() or {})
  end

  local function truncate_list(list, len_overshoot, truncate_method)
    local mid_left = math.ceil(#list/2)
    local mid_right = #list - math.ceil(#list/2) + 1
    local len_truncated = 0
    local truncated_str = ''
    while mid_left > 0 and mid_right <= #list do
      truncated_str = truncate_method(list[mid_left])
      len_truncated = len_truncated + (#list[mid_left] - #truncated_str)
      list[mid_left] = truncated_str
      mid_left = mid_left - 1
      if len_truncated >= len_overshoot then
        return list, 0
      end
      truncated_str = truncate_method(list[mid_right])
      len_truncated = len_truncated + (#list[mid_right] - #truncated_str)
      list[mid_right] = truncated_str
      mid_right = mid_right + 1
      if len_truncated >= len_overshoot then
        return list, 0
      end
    end
    return list, len_overshoot - len_truncated
  end

  local function eval_len(dir_list, file, node_list)

    if not dir_list then dir_list = {} end
    if not file then file = {} end
    if not node_list then node_list = {} end

    local dir_str = concat(vim.tbl_map(function(dir)
      return concat({ dir.icon or '', dir.name or '' })
    end, dir_list), ' ► ')

    local file_str = concat({
      file.icon or '',
      file.name or '',
    })

    local node_str = concat(vim.tbl_map(function(node)
      return concat({
        node.icon or '',
        node.name or ''
      })
    end, node_list), ' ► ')

    local winbar_str = concat({
      dir_str,
      file_str,
      node_str,
    }, ' ► ')
    if not winbar_str:match('^%s*$') then
      winbar_str = ' ' .. winbar_str .. ' '
    end

    return displen(winbar_str)
  end

  local function truncate(dir_list, file, node_list)
    local width = vim.fn.winwidth(0)
    local total_len = eval_len(dir_list, file, node_list)
    local len_overshoot = total_len - width


    if len_overshoot <= 0 then
      return dir_list, file, node_list
    end

    local dir_list_nameonly = vim.tbl_map(function(dir)
      return dir.name
    end, dir_list)
    dir_list_nameonly, len_overshoot =
    truncate_list(dir_list_nameonly, len_overshoot, function(str)
      if displen(str) > 2 then
        return str:sub(1, 1) .. '…'
      end
      return str
    end)
    for i, dir_name in ipairs(dir_list_nameonly) do
      dir_list[i].name = dir_name
    end

    if len_overshoot <= 0 then
      return dir_list, file, node_list
    end

    local node_list_nameonly = vim.tbl_map(function(node)
      return node.name
    end, node_list)
    node_list_nameonly, len_overshoot =
    truncate_list(node_list_nameonly, len_overshoot, function(str)
      if displen(str) > 2 then
        return str:sub(1, 1) .. '…'
      end
      return str
    end)
    for i, node_name in ipairs(node_list_nameonly) do
      node_list[i].name = node_name
    end

    if len_overshoot <= 0 then
      return dir_list, file, node_list
    end

    node_list = {}
    len_overshoot = eval_len(dir_list, file, node_list) - width

    if len_overshoot <= 0 then
      return dir_list, file, node_list
    end

    dir_list = {}
    len_overshoot = eval_len(dir_list, file, node_list) - width

    if len_overshoot <= 0 then
      return dir_list, file, node_list
    end

    return dir_list, file, node_list
  end

  function _G.get_winbar()
    local file = get_file()
    local dir_list = get_dir_list()
    local node_list = get_node_list()
    dir_list, file, node_list = truncate(dir_list, file, node_list)

    -- apply highlights to directory list and
    -- concat with highlighted separators
    local dir_str = concat(vim.tbl_map(function(dir)
      return concat({
        dir.icon or '',
        dir.name or '',
      }, ' ', {
        'Directory',
        'NavicPath',
      })
    end, dir_list), ' ► ', nil, 'Tea')

    -- apply highlights to file name
    local _, iconcolor = require('nvim-web-devicons').get_icon(file,
      vim.fn.fnamemodify(file.name, ':e'), { default = true })
    local file_str = concat({
      file.icon or '',
      file.name or ''
    }, ' ', {
      iconcolor,
      'NavicPath'
    })

    local node_str = concat(vim.tbl_map(function(node)
      return concat({
        node.icon or '',
        node.name or ''
      }, ' ', {
        'NavicIcons' .. (node.type or ''),
        'NavicText'
      })
    end, node_list), ' ► ', nil, 'Orange')

    -- concat three parts with highlighted separators and paddings
    local winbar_str = concat({
      dir_str,
      file_str,
    }, ' ► ', nil, 'Tea')
    winbar_str = concat({
      winbar_str,
      node_str,
    }, ' ► ', nil, 'Orange')
    if not winbar_str:match('^%s*$') then
      winbar_str = ' ' .. winbar_str .. ' '
    end

    return winbar_str
  end

  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'BufWritePost' }, {
    pattern = '*',
    callback = function()
      if vim.api.nvim_win_get_config(0).zindex or vim.bo.buftype ~= ''
          or vim.fn.expand('%') == '' then
        vim.wo.winbar = nil
      else
        vim.wo.winbar = "%{%v:lua.get_winbar()%}"
      end
    end,
  })
end

M['indent-blankline.nvim'] = function()
  vim.opt.listchars = {
    tab        = '→ ',
    extends    = '…',
    precedes   = '…',
    nbsp       = '⌴',
    trail      = '·',
    multispace = '·'
  }
  require('indent_blankline').setup({
    show_current_context = false,
    show_trailing_blankline_indent = false,
    indent_blankline_use_treesitter = false,
  })
end

M['mini.indentscope'] = function()
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    callback = function()
      if vim.bo.bt ~= '' then
        vim.b.miniindentscope_disable = true
      end
    end,
  })
  require('mini.indentscope').setup({
    symbol = '│',
    draw = { delay = 0 }
  })
end

M['twilight.nvim'] = function()
  local twilight = require('twilight')
  local utils = require('modules.ui.utils')
  twilight.setup({
    context = 0,
    dimming = {
      alpha = 0.4,
      color = { 'Turquoise', '#7fa0af' },
      term_bg = '#171d2b',
    },
    exclude = utils.twilight_exclude,
  })

  vim.api.nvim_create_user_command('Twilight', function(_)
    twilight.toggle()
    vim.g.twilight_active = not vim.g.twilight_active
    utils.limelight_check()
  end, { desc = 'Toggle twilight.nvim and limelight.vim' })
  vim.api.nvim_create_user_command('TwilightDisable', function(_)
    twilight.disable()
    vim.g.twilight_active = false
    utils.limelight_check()
  end, { desc = 'Disable twilight.nvim and limelight.vim' })
  vim.api.nvim_create_user_command('TwilightEnable', function(_)
    twilight.enable()
    vim.g.twilight_active = true
    utils.limelight_check()
  end, { desc = 'Enable twilight.nvim and limelight.vim' })

  vim.keymap.set('n', '<Leader>;', '<Cmd>Twilight<CR>', {
    silent = true,
    noremap = true
  })
end

M['limelight.vim'] = function()
  local function set_limelight_conceal_color()
    if vim.o.background == 'dark' then
      vim.g.limelight_conceal_guifg = '#415160'
    else
      vim.g.limelight_conceal_guifg = '#a5b5b8'
    end
  end
  set_limelight_conceal_color()

  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = set_limelight_conceal_color,
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    callback = require('modules.ui.utils').limelight_check,
  })
end

return M
