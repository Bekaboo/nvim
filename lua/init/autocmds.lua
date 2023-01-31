local set_autocmds = function(autocmds)
  for _, autocmd in ipairs(autocmds) do
    vim.api.nvim_create_autocmd(unpack(autocmd))
  end
end

local autocmds = {
  -- Highlight the selection on yank
  {
    { 'TextYankPost' },
    {
      pattern = '*',
      callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
      end
    },
  },

  -- Autosave on focus change
  {
    { 'BufLeave', 'WinLeave', 'FocusLost' },
    {
      pattern = '*',
      command = 'silent! wall',
      nested = true
    },
  },

  -- Jump to last accessed window on closing the current one
  {
    { 'VimEnter', 'WinEnter' },
    {
      pattern = '*',
      callback = function() require('utils.funcs').win_close_jmp() end,
    },
  },

  -- Last-position-jump
  {
    { 'BufReadPost' },
    {
      pattern = '*',
      callback = function() require('utils.funcs').last_pos_jmp() end,
    },
  },

  -- Automatically change local current directory
  {
    { 'BufEnter' },
    {
      pattern = '*',
      callback = function(tbl)
        require('utils.funcs').autocd(tbl.file)
      end,
    },
  },

  -- Automatically create missing directories
  {
    { 'BufWritePre' },
    {
      pattern = '*',
      callback = function()
        vim.fn.mkdir(vim.fn.expand('%:p:h'), 'p')
      end,
    },
  },
}

set_autocmds(autocmds)
