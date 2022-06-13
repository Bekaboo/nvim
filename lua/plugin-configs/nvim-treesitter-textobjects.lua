if not require('utils.funcs').loaded('nvim-treesitter') then
  return
end

local M = {}

local ts_cfg = require('plugin-configs.nvim-treesitter')

M.opts = {
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['am'] = '@function.outer',
        ['im'] = '@function.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['ak'] = '@class.outer',
        ['ik'] = '@class.inner',
        ['ia'] = '@parameter.inner',
        ['aa'] = '@parameter.outer',
        ['a/'] = '@comment.outer',
      }
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@function.outer',
        [']k'] = '@class.outer',
        [']a'] = '@parameter.outer'
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@function.outer',
        [']K'] = '@class.outer',
        [']A'] = '@parameter.outer'
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@function.outer',
        ['[k'] = '@class.outer',
        ['[a'] = '@parameter.outer'
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@function.outer',
        ['[K'] = '@class.outer',
        ['[A'] = '@parameter.outer'
      }
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>al'] = '@parameter.inner'
      },
      swap_previous = {
        ['<leader>ah'] = '@parameter.inner'
      }
    },
    lsp_interop = {
      enable = true,
      border = 'single',
      peek_definition_code = {
        ['<leader>k'] = '@function.outer',
        ['<leader>K'] = '@class.outer',
      },
    }
  }
}
ts_cfg.ts_configs.setup(M.opts)

return M
