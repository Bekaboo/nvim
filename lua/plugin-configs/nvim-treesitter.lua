local M = {}

M.ts_configs = require('nvim-treesitter.configs')
M.ts_opts = {
  ensure_installed = require('utils.shared').langs:list('ts'),
  sync_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false
  },
}
M.ts_configs.setup(M.ts_opts)

-- Automatically install parser for new filetype (with confirmation)
-- From nvim-treesitter issue #2108:
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/2108
-- local ask_install = {}
-- function _G.ensure_treesitter_language_installed()
--   local parsers = require 'nvim-treesitter.parsers'
--   local lang = parsers.get_buf_lang()
--   if parsers.get_parser_configs()[lang] and not parsers.has_parser(lang) and ask_install[lang] ~= false then
--     vim.schedule_wrap(function()
--       vim.ui.select({'yes', 'no'}, { prompt = 'Install tree-sitter parsers for ' .. lang .. '?' }, function(item)
--         if item == 'yes' then
--           vim.cmd('TSInstall ' .. lang)
--         elseif item == 'no' then
--           ask_install[lang] = false
--         end
--       end)
--     end)()
--   end
-- end

-- Automatically install treesitter parsers (no confirmation)
local ts_parsers = require('nvim-treesitter.parsers')
vim.api.nvim_create_autocmd(
  { 'FileType' },
  {
    pattern = '*',
    callback = function()
      local lang = ts_parsers.get_buf_lang()
      if ts_parsers.get_parser_configs()[lang] and not ts_parsers.has_parser(lang) then
        vim.schedule_wrap(function()
          vim.cmd('TSInstall ' .. lang)
        end)()
      end
    end
  }
)

return M
