return {
  'tpope/vim-surround',
  -- To repeat surrounding operations
  requires = require('plugin-specs.vim-repeat')
}
-- Change surrounding from <char1> to <char2>: cs<char1><char2>
-- Change surrounding to <char>: cst<char>
-- Delete surrounding <char>: ds<char>
-- Add surrounding with <char>: ys<text obj><char>
-- Wrap the entire line: yss<char>
-- Surround multiple lines in visual mode (with tags): VS<char>
--                                                    /  \
--                                line-wise visual mode  surround
