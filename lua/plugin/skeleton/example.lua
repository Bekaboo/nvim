require('plugin.skeleton').setup({
  skeldir = vim.fn.stdpath('config') .. '/skeleton',  -- directory where skeleton files are stored
  proj_skeldir = '.skeleton',                         -- project-local skeleton directory name
  apply = {
    new_files = true,             -- apply skeleton to new files
    empty_files = true,           -- apply skeleton to empty existing files
  },
  rules = {
    -- rules for files without filetype
    [''] = {
      ['.*%.scripts/'] = function(fallback)
        return fallback({ 'sh.skel', '.sh.skel' })
      end
    },
    -- rules for lua files
    lua = {
      -- use a function that returns a string to specify
      -- the path to the skeleton file
      ['^init%.lua$'] = function(fallback)
        local stat = vim.loop.fs_stat(vim.fn.stdpath('config') .. '/init.lua')
        if stat and stat.type == 'file' then
          return '~/.config/nvim/init.lua'
        end
        -- use fallback() to search for foo.lua or bar.lua under:
        -- <file_dir>/
        -- <file_dir>/<config.proj_skeldir>/
        -- <file_dir>/<config.proj_skeldir>/lua/
        -- <proj_root>/
        -- <proj_root>/<config.proj_skeldir>/
        -- <proj_root>/<config.proj_skeldir>/lua/
        -- <config.skeldir>/
        -- <config.skeldir>/lua/
        return fallback({ 'foo.lua', 'bar.lua' })
      end,
      -- use non-string or non-function value to disable
      -- skeleton for files matching the pattern
      ['.*garbage.*'] = false,
    },
    python = {
      -- rules for python files
    },
  },
})
