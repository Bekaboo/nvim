local fzf = require('fzf-lua')
local actions = require('fzf-lua.actions')
local core = require('fzf-lua.core')
local path = require('fzf-lua.path')
local config = require('fzf-lua.config')
local utils = require('utils')

local _arg_del = actions.arg_del
local _vimcmd_buf = actions.vimcmd_buf

---@diagnostic disable-next-line: duplicate-set-field
function actions.arg_del(...)
  pcall(_arg_del, ...)
end

---@diagnostic disable-next-line: duplicate-set-field
function actions.vimcmd_buf(...)
  pcall(_vimcmd_buf, ...)
end

local _mt_cmd_wrapper = core.mt_cmd_wrapper

---Wrap `core.mt_cmd_wrapper()` used in fzf-lua's file and grep providers
---to ignore `opts.cwd` when generating the command string because once the
---cwd is hard-coded in the command string, `opts.cwd` will be ignored.
---
---This fixes the bug where `switch_cwd()` does not work if it is used after
---`switch_provider()`:
---
---In `switch_provider()`, `opts.cwd` will be passed the corresponding fzf
---provider (file or grep) where it will be compiled in the command string,
---which will then be stored in `fzf.config.__resume_data.contents`.
---
---`switch_cwd()` internally calls the resume action to resume the last
---provider and reuse other info in previous fzf session (e.g. last query, etc)
---except `opts.cwd`, `opts.fn_selected`, etc. that needs to be changed to
---reflect the new cwd.
---
---Thus if `__resume_data.contents` contains information about the previous
---cwd, the new cwd in `opts.cwd` will be ignored and `switch_cwd()` will not
---take effect.
---@param opts table?
---@diagnostic disable-next-line: duplicate-set-field
function core.mt_cmd_wrapper(opts)
  if not opts or not opts.cwd then
    return _mt_cmd_wrapper(opts)
  end
  local _opts = {}
  for k, v in pairs(opts) do
    _opts[k] = v
  end
  _opts.cwd = nil
  return _mt_cmd_wrapper(_opts)
end

---Switch provider while preserving the last query and cwd
---@return nil
function actions.switch_provider()
  local opts = {
    query = fzf.config.__resume_data.last_query,
    cwd = fzf.config.__resume_data.opts.cwd,
  }
  fzf.builtin({
    actions = {
      ['default'] = function(selected)
        fzf[selected[1]](opts)
      end,
      ['esc'] = actions.resume,
    },
  })
end

---Switch cwd while preserving the last query
---@return nil
function actions.switch_cwd()
  fzf.config.__resume_data.opts = fzf.config.__resume_data.opts or {}
  local opts = fzf.config.__resume_data.opts

  -- Remove old fn_selected, else selected item will be opened
  -- with previous cwd
  opts.fn_selected = nil
  opts.cwd = opts.cwd or vim.uv.cwd()
  opts.query = fzf.config.__resume_data.last_query

  vim.ui.input({
    prompt = 'New cwd: ',
    default = opts.cwd,
    completion = 'dir',
  }, function(input)
    if not input then
      return
    end
    input = vim.fs.normalize(input)
    local stat = vim.uv.fs_stat(input)
    if not stat or not stat.type == 'directory' then
      print('\n')
      vim.notify(
        '[Fzf-lua] invalid path: ' .. input .. '\n',
        vim.log.levels.ERROR
      )
      vim.cmd.redraw()
      return
    end
    opts.cwd = input
  end)

  -- Adapted from fzf-lua `core.set_header()` function
  if opts.cwd_prompt then
    opts.prompt = vim.fn.fnamemodify(opts.cwd, ':.:~')
    local shorten_len = tonumber(opts.cwd_prompt_shorten_len)
    if shorten_len and #opts.prompt >= shorten_len then
      opts.prompt =
        path.shorten(opts.prompt, tonumber(opts.cwd_prompt_shorten_val) or 1)
    end
    if not path.ends_with_separator(opts.prompt) then
      opts.prompt = opts.prompt .. path.separator()
    end
  end

  if opts.headers then
    opts = core.set_header(opts, opts.headers)
  end

  actions.resume()
end

---Include directories, not only files when using the `files` picker
---@return nil
function actions.toggle_dir(_, opts)
  local exe = opts.cmd:match('^%s*(%S+)')
  local flag = opts.toggle_dir_flag
    or (exe == 'fd' or exe == 'fdfind') and '--type d'
    or (exe == 'find') and '-type d'
    or ''
  actions.toggle_flag(_, vim.tbl_extend('force', opts, { toggle_flag = flag }))
end

---Delete selected autocmd
---@return nil
function actions.del_autocmd(selected)
  for _, line in ipairs(selected) do
    local event, group, pattern =
      line:match('^.+:%d+:(%w+)%s*│%s*(%S+)%s*│%s*(.-)%s*│')
    if event and group and pattern then
      vim.cmd.autocmd({
        bang = true,
        args = { group, event, pattern },
        mods = { emsg_silent = true },
      })
    end
  end
  local query = fzf.config.__resume_data.last_query
  fzf.autocmds({
    fzf_opts = {
      ['--query'] = query ~= '' and query or nil,
    },
  })
end

---Search & select files then add them to arglist
---@return nil
function actions.arg_search_add()
  local opts = fzf.config.__resume_data.opts
  fzf.files({
    cwd_header = true,
    cwd_prompt = false,
    headers = { 'actions', 'cwd' },
    prompt = 'Argadd> ',
    actions = {
      ['default'] = function(selected, _opts)
        local cmd = 'argadd'
        vim.ui.input({
          prompt = 'Argadd cmd: ',
          default = cmd,
        }, function(input)
          if input then
            cmd = input
          end
        end)
        actions.vimcmd_file(cmd, selected, _opts)
        fzf.args(opts)
      end,
      ['esc'] = function()
        fzf.args(opts)
      end,
    },
    find_opts = [[-type f -type l -not -path '*/\.git/*' -printf '%P\n']],
    fd_opts = [[--color=never --type f --type l --hidden --follow --exclude .git]],
    rg_opts = [[--color=never --files --hidden --follow -g '!.git'"]],
  })
end

function actions._file_edit_or_qf(selected, opts)
  if #selected > 1 then
    actions.file_sel_to_qf(selected, opts)
    vim.cmd.cfirst()
    vim.cmd.copen()
  else
    actions.file_edit(selected, opts)
  end
end

function actions._file_sel_to_qf(selected, opts)
  actions.file_sel_to_qf(selected, opts)
  if #selected > 1 then
    vim.cmd.cfirst()
    vim.cmd.copen()
  end
end

function actions._file_sel_to_ll(selected, opts)
  actions.file_sel_to_ll(selected, opts)
  if #selected > 1 then
    vim.cmd.lfirst()
    vim.cmd.lopen()
  end
end

core.ACTION_DEFINITIONS[actions.toggle_dir] = {
  function(o)
    -- When using `fd` the flag is '--type d', but for `find` the flag is
    -- '-type d', use '-type d' as default flag here anyway since it is
    -- the common substring for both `find` and `fd` commands
    local flag = o.toggle_dir_flag or '-type d'
    local escape = require('fzf-lua.utils').lua_regex_escape
    return o.cmd and o.cmd:match(escape(flag)) and 'Exclude dirs'
      or 'Include dirs'
  end,
}
core.ACTION_DEFINITIONS[actions.switch_cwd] = { 'Change cwd', pos = 1 }
core.ACTION_DEFINITIONS[actions.arg_del] = { 'delete' }
core.ACTION_DEFINITIONS[actions.del_autocmd] = { 'delete autocmd' }
core.ACTION_DEFINITIONS[actions.arg_search_add] = { 'add new file' }
core.ACTION_DEFINITIONS[actions.search] = { 'edit' }
core.ACTION_DEFINITIONS[actions.ex_run] = { 'edit' }

-- stylua: ignore start
config._action_to_helpstr[actions.toggle_dir] = 'toggle-dir'
config._action_to_helpstr[actions.switch_provider] = 'switch-provider'
config._action_to_helpstr[actions.switch_cwd] = 'change-cwd'
config._action_to_helpstr[actions.arg_del] = 'delete'
config._action_to_helpstr[actions.del_autocmd] = 'delete-autocmd'
config._action_to_helpstr[actions.arg_search_add] = 'search-and-add-new-file'
config._action_to_helpstr[actions.buf_sel_to_qf] = 'buffer-select-to-quickfix'
config._action_to_helpstr[actions.buf_sel_to_ll] = 'buffer-select-to-loclist'
config._action_to_helpstr[actions._file_sel_to_qf] = 'file-select-to-quickfix'
config._action_to_helpstr[actions._file_sel_to_ll] = 'file-select-to-loclist'
config._action_to_helpstr[actions._file_edit_or_qf] = 'file-edit-or-qf'
-- stylua: ignore end

-- Use different prompts for document and workspace diagnostics
-- by overriding `fzf.diagnostics_workspace()` and `fzf.diagnostics_document()`
-- because fzf-lua does not support setting different prompts for them via
-- the `fzf.setup()` function, see `defaults.lua` & `providers/diagnostic.lua`
local _diagnostics_workspace = fzf.diagnostics_workspace
local _diagnostics_document = fzf.diagnostics_document

---@param opts table?
function fzf.diagnostics_document(opts)
  return _diagnostics_document(vim.tbl_extend('force', opts or {}, {
    prompt = 'Document Diagnostics> ',
  }))
end

---@param opts table?
function fzf.diagnostics_workspace(opts)
  return _diagnostics_workspace(vim.tbl_extend('force', opts or {}, {
    prompt = 'Workspace Diagnostics> ',
  }))
end

fzf.setup({
  -- Use nbsp in tty to avoid showing box chars
  nbsp = not vim.g.modern_ui and '\xc2\xa0' or nil,
  dir_icon = vim.trim(utils.static.icons.Folder),
  winopts = {
    backdrop = 100,
    split = [[
        let tabpage_win_list = nvim_tabpage_list_wins(0) |
        \ call v:lua.require'utils.win'.saveheights(tabpage_win_list) |
        \ call v:lua.require'utils.win'.saveviews(tabpage_win_list) |
        \ unlet tabpage_win_list |
        \ let g:_fzf_vim_lines = &lines |
        \ let g:_fzf_leave_win = win_getid(winnr()) |
        \ let g:_fzf_splitkeep = &splitkeep | let &splitkeep = "topline" |
        \ let g:_fzf_cmdheight = &cmdheight | let &cmdheight = 0 |
        \ let g:_fzf_laststatus = &laststatus | let &laststatus = 0 |
        \ botright 10new |
        \ exe 'resize' .
          \ (10 + g:_fzf_cmdheight + (g:_fzf_laststatus ? 1 : 0)) |
        \ let w:winbar_no_attach = v:true |
        \ setlocal bt=nofile bh=wipe nobl noswf wfh
    ]],
    on_create = function()
      vim.keymap.set(
        't',
        '<C-r>',
        [['<C-\><C-N>"' . nr2char(getchar()) . 'pi']],
        { expr = true, buffer = true }
      )
    end,
    on_close = function()
      ---@param name string
      ---@return nil
      local function _restore_global_opt(name)
        if vim.g['_fzf_' .. name] then
          vim.go[name] = vim.g['_fzf_' .. name]
          vim.g['_fzf_' .. name] = nil
        end
      end

      _restore_global_opt('splitkeep')
      _restore_global_opt('cmdheight')
      _restore_global_opt('laststatus')

      if
        vim.g._fzf_leave_win
        and vim.api.nvim_win_is_valid(vim.g._fzf_leave_win)
        and vim.api.nvim_get_current_win() ~= vim.g._fzf_leave_win
      then
        vim.api.nvim_set_current_win(vim.g._fzf_leave_win)
      end
      vim.g._fzf_leave_win = nil

      if vim.go.lines == vim.g._fzf_vim_lines then
        utils.win.restheights()
      end
      vim.g._fzf_vim_lines = nil
      utils.win.clearheights()
      utils.win.restviews()
      utils.win.clearviews()
    end,
    preview = {
      hidden = 'hidden',
    },
  },
  hls = {
    title = 'TelescopeTitle',
    preview_title = 'TelescopeTitle',
    -- Builtin preview only
    cursor = 'Cursor',
    cursorline = 'TelescopePreviewLine',
    cursorlinenr = 'TelescopePreviewLine',
    search = 'IncSearch',
  },
  fzf_colors = {
    ['hl'] = { 'fg', 'TelescopeMatching' },
    ['fg+'] = { 'fg', 'TelescopeSelection' },
    ['bg+'] = { 'bg', 'TelescopeSelection' },
    ['hl+'] = { 'fg', 'TelescopeMatching' },
    ['info'] = { 'fg', 'TelescopeCounter' },
    ['prompt'] = { 'fg', 'TelescopePrefix' },
    ['pointer'] = { 'fg', 'TelescopeSelectionCaret' },
    ['marker'] = { 'fg', 'TelescopeMultiIcon' },
  },
  keymap = {
    -- Overrides default completion completely
    builtin = {
      ['<F1>'] = 'toggle-help',
      ['<F2>'] = 'toggle-fullscreen',
    },
    fzf = {
      -- fzf '--bind=' options
      ['ctrl-z'] = 'abort',
      ['ctrl-k'] = 'kill-line',
      ['ctrl-u'] = 'unix-line-discard',
      ['ctrl-a'] = 'beginning-of-line',
      ['ctrl-e'] = 'end-of-line',
      ['alt-a'] = 'toggle-all',
      ['alt-}'] = 'last',
      ['alt-{'] = 'first',
    },
  },
  actions = {
    files = {
      ['alt-s'] = actions.file_split,
      ['alt-v'] = actions.file_vsplit,
      ['alt-t'] = actions.file_tabedit,
      ['alt-q'] = actions._file_sel_to_qf,
      ['alt-o'] = actions._file_sel_to_ll,
      ['default'] = actions._file_edit_or_qf,
    },
    buffers = {
      ['default'] = actions.buf_edit,
      ['alt-s'] = actions.buf_split,
      ['alt-v'] = actions.buf_vsplit,
      ['alt-t'] = actions.buf_tabedit,
    },
  },
  defaults = {
    headers = { 'actions' },
    actions = {
      ['ctrl-]'] = actions.switch_provider,
    },
  },
  args = {
    files_only = false,
    actions = {
      ['ctrl-s'] = actions.arg_search_add,
      ['ctrl-x'] = {
        fn = actions.arg_del,
        reload = true,
      },
    },
  },
  autocmds = {
    actions = {
      ['ctrl-x'] = {
        fn = actions.del_autocmd,
        -- reload = true,
      },
    },
  },
  blines = {
    actions = {
      ['alt-q'] = actions.buf_sel_to_qf,
      ['alt-o'] = actions.buf_sel_to_ll,
      ['alt-l'] = false,
    },
  },
  lines = {
    actions = {
      ['alt-q'] = actions.buf_sel_to_qf,
      ['alt-o'] = actions.buf_sel_to_ll,
      ['alt-l'] = false,
    },
  },
  buffers = {
    show_unlisted = true,
    show_unloaded = true,
    ignore_current_buffer = false,
    no_action_set_cursor = true,
    current_tab_only = false,
    no_term_buffers = false,
    cwd_only = false,
    ls_cmd = 'ls',
  },
  helptags = {
    actions = {
      ['default'] = actions.help,
      ['alt-s'] = actions.help,
      ['alt-v'] = actions.help_vert,
      ['alt-t'] = actions.help_tab,
    },
  },
  manpages = {
    actions = {
      ['default'] = actions.man,
      ['alt-s'] = actions.man,
      ['alt-v'] = actions.man_vert,
      ['alt-t'] = actions.man_tab,
    },
  },
  keymaps = {
    actions = {
      ['default'] = actions.keymap_edit,
      ['alt-s'] = actions.keymap_split,
      ['alt-v'] = actions.keymap_vsplit,
      ['alt-t'] = actions.keymap_tabedit,
    },
  },
  colorschemes = {
    actions = {
      ['default'] = actions.colorscheme,
    },
  },
  highlights = {
    actions = {
      ['default'] = function(selected)
        vim.defer_fn(function()
          vim.cmd.hi(selected[1])
        end, 0)
      end,
    },
  },
  command_history = {
    actions = {
      ['alt-e'] = actions.ex_run,
      ['ctrl-e'] = false,
    },
  },
  search_history = {
    actions = {
      ['alt-e'] = actions.search,
      ['ctrl-e'] = false,
    },
  },
  files = {
    actions = {
      ['alt-c'] = actions.switch_cwd,
      ['ctrl-/'] = actions.toggle_dir,
      ['ctrl-g'] = actions.toggle_ignore,
    },
    fzf_opts = {
      ['--info'] = 'inline-right',
    },
    find_opts = [[-type f -type l -not -path '*/\.git/*' -printf '%P\n']],
    fd_opts = [[--color=never --type f --type l --hidden --follow --exclude .git]],
    rg_opts = [[--color=never --files --hidden --follow -g '!.git'"]],
  },
  oldfiles = {
    prompt = 'Oldfiles> ',
  },
  fzf_opts = {
    ['--no-scrollbar'] = '',
    ['--no-separator'] = '',
    ['--info'] = 'inline-right',
    ['--layout'] = 'reverse',
    ['--marker'] = '+',
    ['--pointer'] = '→',
    ['--prompt'] = '/ ',
    ['--border'] = 'none',
    ['--padding'] = '0,1',
    ['--margin'] = '0',
    ['--no-preview'] = '',
    ['--preview-window'] = 'hidden',
  },
  grep = {
    actions = {
      ['alt-c'] = actions.switch_cwd,
    },
    rg_opts = table.concat({
      '--hidden',
      '--follow',
      '--smart-case',
      '--column',
      '--line-number',
      '--no-heading',
      '--color=always',
      '-g=!.git/',
      '-e',
    }, ' '),
    fzf_opts = {
      ['--info'] = 'inline-right',
    },
  },
  lsp = {
    finder = {
      fzf_opts = {
        ['--info'] = 'inline-right',
      },
    },
    definitions = {
      sync = false,
      jump_to_single_result = true,
    },
    references = {
      sync = false,
      ignore_current_line = true,
      jump_to_single_result = true,
    },
    typedefs = {
      sync = false,
      jump_to_single_result = true,
    },
    symbols = {
      symbol_icons = vim.tbl_map(vim.trim, utils.static.icons.kinds),
    },
  },
})

vim.keymap.set('n', '<Leader>.', fzf.files)
vim.keymap.set('n', "<Leader>'", fzf.resume)
vim.keymap.set('n', '<Leader>,', fzf.buffers)
vim.keymap.set('n', '<Leader>/', fzf.live_grep)
vim.keymap.set('n', '<Leader>?', fzf.help_tags)
vim.keymap.set('n', '<Leader>*', fzf.grep_cword)
vim.keymap.set('x', '<Leader>*', fzf.grep_visual)
vim.keymap.set('n', '<Leader>#', fzf.grep_cword)
vim.keymap.set('x', '<Leader>#', fzf.grep_visual)
vim.keymap.set('n', '<Leader>"', fzf.registers)
vim.keymap.set('n', '<Leader>F', fzf.builtin)
vim.keymap.set('n', '<Leader>o', fzf.oldfiles)
vim.keymap.set('n', '<Leader>-', fzf.blines)
vim.keymap.set('n', '<Leader>=', fzf.lines)
vim.keymap.set('n', '<Leader>R', fzf.lsp_finder)
vim.keymap.set('n', '<Leader>f', fzf.builtin)
vim.keymap.set('n', '<Leader>f"', fzf.registers)
vim.keymap.set('n', '<Leader>f*', fzf.grep_cword)
vim.keymap.set('x', '<Leader>f*', fzf.grep_visual)
vim.keymap.set('n', '<Leader>f#', fzf.grep_cword)
vim.keymap.set('x', '<Leader>f#', fzf.grep_visual)
vim.keymap.set('n', '<Leader>f:', fzf.commands)
vim.keymap.set('n', '<Leader>f/', fzf.live_grep)
vim.keymap.set('n', '<Leader>fE', fzf.diagnostics_workspace)
vim.keymap.set('n', '<Leader>fH', fzf.highlights)
vim.keymap.set('n', "<Leader>f'", fzf.resume)
vim.keymap.set('n', '<Leader>fA', fzf.autocmds)
vim.keymap.set('n', '<Leader>fb', fzf.buffers)
vim.keymap.set('n', '<Leader>fc', fzf.changes)
vim.keymap.set('n', '<Leader>fe', fzf.diagnostics_document)
vim.keymap.set('n', '<Leader>ff', fzf.files)
vim.keymap.set('n', '<Leader>fa', fzf.args)
vim.keymap.set('n', '<Leader>fl', fzf.loclist)
vim.keymap.set('n', '<Leader>fq', fzf.quickfix)
vim.keymap.set('n', '<Leader>fL', fzf.loclist_stack)
vim.keymap.set('n', '<Leader>fQ', fzf.quickfix_stack)
vim.keymap.set('n', '<Leader>fgt', fzf.git_tags)
vim.keymap.set('n', '<Leader>fgs', fzf.git_stash)
vim.keymap.set('n', '<Leader>fgg', fzf.git_status)
vim.keymap.set('n', '<Leader>fgc', fzf.git_commits)
vim.keymap.set('n', '<Leader>fgl', fzf.git_bcommits)
vim.keymap.set('n', '<Leader>fgb', fzf.git_branches)
vim.keymap.set('n', '<Leader>fh', fzf.help_tags)
vim.keymap.set('n', '<Leader>f?', fzf.help_tags)
vim.keymap.set('n', '<Leader>fk', fzf.keymaps)
vim.keymap.set('n', '<Leader>f-', fzf.blines)
vim.keymap.set('n', '<Leader>f=', fzf.lines)
vim.keymap.set('n', '<Leader>fm', fzf.marks)
vim.keymap.set('n', '<Leader>fo', fzf.oldfiles)
vim.keymap.set('n', '<Leader>fD', fzf.lsp_typedefs)
vim.keymap.set('n', '<Leader>fd', fzf.lsp_definitions)
vim.keymap.set('n', '<Leader>fs', fzf.lsp_document_symbols)
vim.keymap.set('n', '<Leader>fS', fzf.lsp_live_workspace_symbols)
vim.keymap.set('n', '<Leader>fi', fzf.lsp_implementations)
vim.keymap.set('n', '<Leader>f<', fzf.lsp_incoming_calls)
vim.keymap.set('n', '<Leader>f>', fzf.lsp_outgoing_calls)
vim.keymap.set('n', '<Leader>fr', fzf.lsp_references)
vim.keymap.set('n', '<Leader>fR', fzf.lsp_finder)

local _lsp_workspace_symbol = vim.lsp.buf.workspace_symbol

---Overriding `vim.lsp.buf.workspace_symbol()`, not only the handler here
---to skip the 'Query:' input prompt -- with `fzf.lsp_live_workspace_symbols()`
---as handler we can update the query in live
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.buf.workspace_symbol(query, options)
  _lsp_workspace_symbol(query or '', options)
end

vim.lsp.handlers['callHierarchy/incomingCalls'] = fzf.lsp_incoming_calls
vim.lsp.handlers['callHierarchy/outgoingCalls'] = fzf.lsp_outgoing_calls
vim.lsp.handlers['textDocument/codeAction'] = fzf.code_actions
vim.lsp.handlers['textDocument/declaration'] = fzf.declarations
vim.lsp.handlers['textDocument/definition'] = fzf.lsp_definitions
vim.lsp.handlers['textDocument/documentSymbol'] = fzf.lsp_document_symbols
vim.lsp.handlers['textDocument/implementation'] = fzf.lsp_implementations
vim.lsp.handlers['textDocument/references'] = fzf.lsp_references
vim.lsp.handlers['textDocument/typeDefinition'] = fzf.lsp_typedefs
vim.lsp.handlers['workspace/symbol'] = fzf.lsp_live_workspace_symbols

vim.diagnostic.setqflist = fzf.diagnostics_workspace
vim.diagnostic.setloclist = fzf.diagnostics_document

vim.api.nvim_create_user_command('FZF', function(info)
  fzf.files({ cwd = info.fargs[1] })
end, {
  nargs = '?',
  complete = 'dir',
  desc = 'Fuzzy find files.',
})

---Generate a completion function for user command that wraps a builtin command
---@param user_cmd string user command pattern
---@param builtin_cmd string builtin command
---@return fun(_, cmdline: string, cursorpos: integer): string[]
local function complfn(user_cmd, builtin_cmd)
  return function(_, cmdline, cursorpos)
    local cmdline_before =
      cmdline:sub(1, cursorpos):gsub(user_cmd, builtin_cmd, 1)
    return vim.fn.getcompletion(cmdline_before, 'cmdline')
  end
end

local fzf_ls_cmd = {
  function(info)
    local suffix = string.format('%s %s', info.bang and '!' or '', info.args)
    return fzf.buffers({
      prompt = vim.trim(info.name .. suffix) .. '> ',
      ls_cmd = 'ls' .. suffix,
    })
  end,
  {
    bang = true,
    nargs = '?',
    complete = function()
      return {
        '+',
        '-',
        '=',
        'a',
        'u',
        'h',
        'x',
        '%',
        '#',
        'R',
        'F',
        't',
      }
    end,
  },
}

local fzf_hi_cmd = {
  function(info)
    if vim.tbl_isempty(info.fargs) then
      fzf.highlights()
      return
    end
    if #info.fargs == 1 and info.fargs[1] ~= 'clear' then
      local hlgroup = info.fargs[1]
      if vim.fn.hlexists(hlgroup) == 1 then
        vim.cmd.hi({
          args = { hlgroup },
          bang = info.bang,
        })
      else
        fzf.highlights({
          fzf_opts = {
            ['--query'] = hlgroup,
          },
        })
      end
      return
    end
    vim.cmd.hi({
      args = info.fargs,
      bang = info.bang,
    })
  end,
  {
    bang = true,
    nargs = '*',
    complete = complfn('Highlight', 'hi'),
  },
}

local fzf_reg_cmd = {
  function(info)
    local query = table.concat(
      vim.tbl_map(
        function(reg)
          return string.format('^[%s]', reg:upper())
        end,
        vim.split(info.args, '', {
          trimempty = true,
        })
      ),
      ' | '
    )
    fzf.registers({
      fzf_opts = {
        ['--query'] = query ~= '' and query or nil,
      },
    })
  end,
  {
    nargs = '*',
    complete = complfn('Registers', 'registers'),
  },
}

local fzf_display_cmd = vim.tbl_deep_extend('force', fzf_reg_cmd, {
  [2] = { complete = complfn('Display', 'display') },
})

local fzf_au_cmd = {
  function(info)
    if #info.fargs <= 1 and not info.bang then
      fzf.autocmds({
        fzf_opts = {
          ['--query'] = info.fargs[1] ~= '' and info.fargs[1] or nil,
        },
      })
      return
    end
    vim.cmd.autocmd({
      args = info.fargs,
      bang = info.bang,
    })
  end,
  {
    bang = true,
    nargs = '*',
    complete = complfn('Autocmd', 'autocmd'),
  },
}

local fzf_marks_cmd = {
  function(info)
    local query = table.concat(
      vim.tbl_map(
        function(mark)
          return '^' .. mark
        end,
        vim.split(info.args, '', {
          trimempty = true,
        })
      ),
      ' | '
    )
    fzf.marks({
      fzf_opts = {
        ['--query'] = query ~= '' and query or nil,
      },
    })
  end,
  {
    nargs = '*',
    complete = complfn('Marks', 'marks'),
  },
}

local fzf_args_cmd = {
  function(info)
    if not info.bang and vim.tbl_isempty(info.fargs) then
      fzf.args()
      return
    end
    vim.cmd.args({
      args = info.fargs,
      bang = info.bang,
    })
  end,
  {
    bang = true,
    nargs = '*',
    complete = complfn('Args', 'args'),
  },
}

-- stylua: ignore start
vim.api.nvim_create_user_command('Ls', unpack(fzf_ls_cmd))
vim.api.nvim_create_user_command('Files', unpack(fzf_ls_cmd))
vim.api.nvim_create_user_command('Args', unpack(fzf_args_cmd))
vim.api.nvim_create_user_command('Autocmd', unpack(fzf_au_cmd))
vim.api.nvim_create_user_command('Buffers', unpack(fzf_ls_cmd))
vim.api.nvim_create_user_command('Marks', unpack(fzf_marks_cmd))
vim.api.nvim_create_user_command('Highlight', unpack(fzf_hi_cmd))
vim.api.nvim_create_user_command('Registers', unpack(fzf_reg_cmd))
vim.api.nvim_create_user_command('Display', unpack(fzf_display_cmd))
vim.api.nvim_create_user_command('Oldfiles', fzf.oldfiles, {})
vim.api.nvim_create_user_command('Changes', fzf.changes, {})
vim.api.nvim_create_user_command('Tags', fzf.tagstack, {})
vim.api.nvim_create_user_command('Jumps', fzf.jumps, {})
vim.api.nvim_create_user_command('Tabs', fzf.tabs, {})
-- stylua: ignore end

---Set telescope default hlgroups for a borderless view
---@return nil
local function set_default_hlgroups()
  local hl = utils.hl
  local hl_norm = hl.get(0, { name = 'Normal', link = false })
  local hl_special = hl.get(0, { name = 'Special', link = false })
  hl.set(0, 'FzfLuaBufFlagAlt', {})
  hl.set(0, 'FzfLuaBufFlagCur', {})
  hl.set(0, 'FzfLuaBufName', {})
  hl.set(0, 'FzfLuaBufNr', {})
  hl.set(0, 'FzfLuaBufLineNr', { link = 'LineNr' })
  hl.set(0, 'FzfLuaCursor', { link = 'None' })
  hl.set(0, 'FzfLuaHeaderBind', { link = 'Special' })
  hl.set(0, 'FzfLuaHeaderText', { link = 'Special' })
  hl.set(0, 'FzfLuaTabMarker', { link = 'Keyword' })
  hl.set(0, 'FzfLuaTabTitle', { link = 'Title' })
  hl.set_default(0, 'TelescopeSelection', { link = 'Visual' })
  hl.set_default(0, 'TelescopePrefix', { link = 'Operator' })
  hl.set_default(0, 'TelescopeCounter', { link = 'LineNr' })
  hl.set_default(0, 'TelescopeTitle', {
    fg = hl_norm.bg,
    bg = hl_special.fg,
    bold = true,
  })
end

set_default_hlgroups()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('FzfLuaSetDefaultHlgroups', {}),
  desc = 'Set default hlgroups for fzf-lua.',
  callback = set_default_hlgroups,
})
