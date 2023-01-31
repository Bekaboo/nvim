local M = {}

M['mason.nvim'] = function()
  require('mason').setup({
    ui = {
      border = 'single',
      width = 0.7,
      height = 0.74,
      icons = {
        package_installed = '',
        package_pending = '',
        package_uninstalled = '',
      },
      keymaps = {
        -- Keymap to expand a package
        toggle_package_expand = '<Tab>',
        -- Keymap to uninstall a package
        uninstall_package = 'x',
      },
    },
  })
end

M['telescope.nvim'] = function()
  local telescope = require('telescope')
  local telescope_builtin = require('telescope.builtin')
  local telescope_actions = require('telescope.actions')

  local keymap_opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<Leader>F', function() telescope_builtin.builtin() end, keymap_opts)
  vim.keymap.set('n', '<Leader>ff', function() telescope_builtin.find_files() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fo', function() telescope_builtin.oldfiles() end, keymap_opts)
  vim.keymap.set('n', '<Leader>f;', function() telescope_builtin.live_grep() end, keymap_opts)
  vim.keymap.set('n', '<Leader>f*', function() telescope_builtin.grep_string() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fh', function() telescope_builtin.help_tags() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fb', function() telescope_builtin.current_buffer_fuzzy_find() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fr', function() telescope_builtin.lsp_references({ jump_type = 'never', include_current_line = true }) end, keymap_opts)
  vim.keymap.set('n', '<Leader>fd', function() telescope_builtin.lsp_definitions({ jump_type = 'never', include_current_line = true }) end, keymap_opts)
  vim.keymap.set('n', '<Leader>fa', function() telescope_builtin.lsp_code_actions() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fe', function() telescope_builtin.diagnostics() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fp', function() telescope_builtin.treesitter() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fs', function() telescope_builtin.lsp_document_symbols() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fS', function() telescope_builtin.lsp_workspace_symbols() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fg', function() telescope_builtin.git_status() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fm', function() telescope_builtin.marks() end, keymap_opts)

  telescope.setup({
    defaults = {
      prompt_prefix = '/ ',
      selection_caret = '→ ',
      borderchars = require('utils.static').borders.single,
      layout_config = {
        horizontal = { prompt_position = 'top', preview_width = 0.5 },
        vertical = { prompt_position = 'top', preview_width = 0.5 }
      },
      sorting_strategy = 'ascending',
      file_ignore_patterns = { '.git/', '%.pdf', '%.o', '%.zip' },
      mappings = {
        i = {
          ['<M-c>'] = telescope_actions.close,
          ['<M-s>'] = telescope_actions.select_horizontal,
          ['<M-v>'] = telescope_actions.select_vertical,
          ['<M-t>'] = telescope_actions.select_tab,
          ['<M-Q>'] = telescope_actions.send_to_qflist + telescope_actions.open_qflist,
        },

        n = {
          ['q'] = telescope_actions.close,
          ['<esc>'] = telescope_actions.close,
          ['<M-c>'] = telescope_actions.close,
          ['<M-s>'] = telescope_actions.select_horizontal,
          ['<M-v>'] = telescope_actions.select_vertical,
          ['<M-t>'] = telescope_actions.select_tab,
          ['<M-Q>'] = telescope_actions.send_to_qflist + telescope_actions.open_qflist,
          ['<C-n>'] = telescope_actions.move_selection_next,
          ['<C-p>'] = telescope_actions.move_selection_previous,
        },
      },
    },
  })

  -- load telescope extensions
  telescope.load_extension('fzf')
end

M['undotree'] = function()
  vim.g.undotree_SplitWidth = 30
  vim.g.undotree_ShortIndicators = 1
  vim.g.undotree_WindowLayout = 3
  vim.g.undotree_DiffpanelHeight = 16
  vim.g.undotree_SetFocusWhenToggle = 1
  vim.api.nvim_set_keymap('n', '<Leader>u', '<cmd>UndotreeToggle<CR>', { noremap = true })
end

M['vim-floaterm'] = function()
  vim.cmd([[
    let g:floaterm_width = 0.7
    let g:floaterm_height = 0.74
    let g:floaterm_opener = 'edit'

    function! s:get_bufnr_unnamed(buflist) abort
      for bufnr in a:buflist
        let name = getbufvar(bufnr, 'floaterm_name')
        if empty(name)
          return bufnr
        endif
      endfor
      return -1
    endfunction

    function! ToggleTool(tool, count) abort
      " Close other floating terminal window if present
      let winlist = filter(range(1, winnr('$')),
        \ 'getwinvar(v:val, "&buftype") ==# "terminal"')
      for winnr in winlist
        if getbufvar(winbufnr(winnr), '&filetype') !=# 'floaterm'
          execute winnr.'wincmd c'
        endif
      endfor

      " If current buffer is a floaterm?
      let bufnr = bufnr('%')
      let buflist = floaterm#buflist#gather()
      if index(buflist, bufnr) == -1
        " find an appropriate floaterm according to the
        " tool name if current buffer is not a floaterm
        let bufnr = empty(a:tool) ?
          \ s:get_bufnr_unnamed(buflist) : floaterm#terminal#get_bufnr(a:tool)
      endif

      " Create a new one if cannot find an appropriate floaterm
      if bufnr == -1
        if empty(a:tool)
          " ToggleTool should only be called from
          " normal mode or terminal mode without bang
          call floaterm#run('new', 0, [visualmode(), 0, 0, 0], '')
        else
          call floaterm#run('new', 0, [visualmode(), 0, 0, 0],
            \ printf('--title=%s($1/$2) --name=%s %s', a:tool, a:tool, a:tool))
        endif
      else  " Current buffer is a floaterm, or current buffer is not
            " a floaterm but an appropriate floaterm is found
        call floaterm#toggle(0, a:count ? a:count : bufnr, '')
        " workaround to prevent lazygit shift left;
        " another workaround here is to use sidlent!
        " to ignore can't re-enter normal mode error
        execute('silent! normal! 0')
      endif
    endfunction

    command! -nargs=? -count=0 -complete=customlist,floaterm#cmdline#complete_names1
        \ ToggleTool call ToggleTool(<q-args>, <count>)
    nnoremap <silent> <M-i> <Cmd>execute v:count . 'ToggleTool lazygit'<CR>
    tnoremap <silent> <M-i> <Cmd>execute v:count . 'ToggleTool lazygit'<CR>
    nnoremap <silent> <C-\> <Cmd>execute v:count . 'ToggleTool'<CR>
    tnoremap <silent> <C-\> <Cmd>execute v:count . 'ToggleTool'<CR>

    autocmd User FloatermOpen nnoremap <buffer> <silent> <C-S-K> <Cmd>FloatermPrev<CR>
    autocmd User FloatermOpen tnoremap <buffer> <silent> <C-S-K> <Cmd>FloatermPrev<CR>
    autocmd User FloatermOpen nnoremap <buffer> <silent> <S-NL> <Cmd>FloatermNext<CR>
    autocmd User FloatermOpen tnoremap <buffer> <silent> <S-NL> <Cmd>FloatermNext<CR>
    " Auto resize floaterm when window is resized
    autocmd VimResized * if &filetype ==# 'floaterm' | exe 'FloatermHide' | exe 'FloatermShow' | endif
  ]])
end

M['gitsigns.nvim'] = function()
  require('gitsigns').setup({
    signs = {
      add = { text = '+' },
      untracked = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 100,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map({ 'n', 'x' }, ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      map({ 'n', 'x' }, '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      -- Actions
      map('n', '<leader>gs', gs.stage_hunk)
      map('n', '<leader>gr', gs.reset_hunk)
      map('n', '<leader>gS', gs.stage_buffer)
      map('n', '<leader>gu', gs.undo_stage_hunk)
      map('n', '<leader>gR', gs.reset_buffer)
      map('n', '<leader>gp', gs.preview_hunk)
      map('n', '<leader>gb', function() gs.blame_line { full = false } end)
      map('n', '<leader>gB', function() gs.blame_line { full = true } end)
      map('n', '<leader>gd', gs.diffthis)
      map('n', '<leader>gD', function() gs.diffthis('~') end)

      -- Text object
      map({ 'o', 'x' }, 'ic', ':<C-U>Gitsigns select_hunk<CR>')
      map({ 'o', 'x' }, 'ac', ':<C-U>Gitsigns select_hunk<CR>')
    end,
  })
end

M['rnvimr'] = function()
  vim.g.rnvimr_enable_ex = 1
  vim.g.rnvimr_enable_picker = 1
  vim.g.rnvimr_enable_bw = 1
  vim.g.rnvimr_ranger_cmd = { 'ranger', '--cmd=set draw_borders both' }
  vim.g.rnvimr_action = {
    ['<A-t>'] = 'NvimEdit tabedit',
    ['<A-s>'] = 'NvimEdit split',
    ['<A-v>'] = 'NvimEdit vsplit',
    ['gw'] = 'JumpNvimCwd',
    ['yw'] = 'EmitRangerCwd'
  }

  local function change_highlight_colorscheme()
    if vim.o.background == 'dark' then
      os.execute('ln -fs ~/.highlight/themes/falcon-dark.theme '..
                 '~/.highlight/themes/falcon.theme')
    else
      os.execute('ln -fs ~/.highlight/themes/falcon-light.theme ' ..
                 '~/.highlight/themes/falcon.theme')
    end
  end

  vim.keymap.set({ 'n', 't' }, '<M-e>', function()
    local winlist = vim.api.nvim_list_wins()
    for _, winnr in ipairs(winlist) do
      local bufnr = vim.api.nvim_win_get_buf(winnr)
      if vim.api.nvim_win_get_config(winnr).relative ~= ''
          and vim.fn.getwinvar(winnr, '&buftype') == 'terminal'
          and vim.fn.getbufvar(bufnr, '&filetype') ~= 'rnvimr' then
        vim.api.nvim_win_close(winnr, true)
      end
    end
    change_highlight_colorscheme()
    vim.cmd('silent! RnvimrToggle')
  end, { noremap = true })

  vim.api.nvim_create_autocmd({ 'TermOpen', 'ColorScheme' }, {
    pattern = '*',
    callback = change_highlight_colorscheme,
  })

  vim.api.nvim_create_autocmd('VimLeave', {
    pattern = '*',
    callback = function()
      os.execute('ln -fs ~/.highlight/themes/falcon-dark.theme '..
                 '~/.highlight/themes/falcon.theme')
    end,
  })
end

M['tmux.nvim'] = function()
  local tmux = require('tmux')
  tmux.setup({
    copy_sync = {
      enable = false,
    },
    navigation = {
      cycle_navigation = false,
      enable_default_keybindings = false,
    },
    resize = {
      enable_default_keybindings = false,
    },
  })

  vim.keymap.set('n', '<M-h>', tmux.move_left, { noremap = true })
  vim.keymap.set('n', '<M-j>', tmux.move_bottom, { noremap = true })
  vim.keymap.set('n', '<M-k>', tmux.move_top, { noremap = true })
  vim.keymap.set('n', '<M-l>', tmux.move_right, { noremap = true })
end

M['nvim-colorizer.lua'] = function()
  require('colorizer').setup({
    user_default_options = {
      names = false,
      RRGGBBAA = true,
      AARRGGBB = true,
      rgb_fn = true,
      hsl_fn = true,
    }
  })
end

return M
