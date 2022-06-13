local M = {}

M.cmp = require 'cmp'

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local icons = require('utils.shared').icons

M.opts = {
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      vim_item.menu = '[' .. string.upper(entry.source.name) .. ']'
      -- Do not show kind icon for emoji
      if entry.source.name == 'emoji' then
        vim_item.kind = ''
        -- Use a terminal icon for completions from cmp-cmdline
      elseif entry.source.name == 'cmdline' then
        vim_item.kind = icons.Terminal .. ' '
      elseif entry.source.name == 'calc' then
        vim_item.kind = icons.Calculator .. ' '
      else
        vim_item.kind = string.format('%s ', icons[vim_item.kind])
      end
      -- Max word length visible
      if #(vim_item.abbr) > 30 then
        vim_item.abbr = string.sub(vim_item.abbr, 1, 18)
            .. '…'
            .. string.sub(vim_item.abbr, -11, -1)
      end

      return vim_item
    end
  },
  experimental = { ghost_text = true },
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end
  },
  mapping = {
    ['<S-Tab>'] = M.cmp.mapping(function()
      if M.cmp.visible() then
        M.cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      end
    end, { 'i', 'c' }),
    ['<Tab>'] = M.cmp.mapping(function(fallback)
      if M.cmp.visible() then
        M.cmp.select_next_item()
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      else
        fallback()
      end
    end, { 'i', 'c' }),
    ['<C-p>'] = M.cmp.mapping.select_prev_item(),
    ['<C-n>'] = M.cmp.mapping.select_next_item(),
    ['<C-b>'] = M.cmp.mapping.scroll_docs(-8),
    ['<C-f>'] = M.cmp.mapping.scroll_docs(8),
    ['<C-u>'] = M.cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = M.cmp.mapping.scroll_docs(4),
    ['<C-y>'] = M.cmp.mapping.scroll_docs(-1),
    ['<C-e>'] = M.cmp.mapping.scroll_docs(1),
    ['<M-;>'] = M.cmp.mapping(function()
      if M.cmp.visible() then
        M.cmp.close()
      else
        M.cmp.complete()
      end
    end, { 'i', 'c' }),
    ['<esc>'] = M.cmp.mapping(function(fallback)
      if M.cmp.visible() then
        M.cmp.abort()
      else
        fallback()
      end
    end, { 'i', 'c' }),
    ['<CR>'] = M.cmp.mapping.confirm {
      behavior = M.cmp.ConfirmBehavior.Replace,
      select = false
    }
  },
  sources = {
    { name = 'nvim_lsp' }, { name = 'path' },
    { name = 'spell', max_item_count = 5 },
    { name = 'buffer', max_item_count = 10 },
    { name = 'vsnip' }, { name = 'calc' }, { name = 'emoji' }
  },
  sorting = {
    comparators = {
      M.cmp.config.compare.score,
      M.cmp.config.compare.offset, M.cmp.config.compare.exact,
      M.cmp.config.compare.kind, M.cmp.config.compare.sort_text,
      M.cmp.config.compare.length, M.cmp.config.compare.order
    }
  },
  -- cmp floating window config
  window = {
    completion = { border = 'single' },
    documentation = { border = 'single' }
  }
}
M.cmp.setup(M.opts)

M.opts_cmdline = {}
M.opts_cmdline['/'] = { sources = { { name = 'buffer' } } }
M.opts_cmdline[':'] = {
  sources = {
    { name = 'path' },
    -- Do not show completion for words starting with '!' (huge lag, why?)
    { name = 'cmdline', keyword_pattern = [[\!\@<!\w*]] },
  }
}
-- Use buffer source for `/`.
M.cmp.setup.cmdline('/', M.opts_cmdline['/'])
-- Use cmdline & path source for ':'.
M.cmp.setup.cmdline(':', M.opts_cmdline[':'])

return M
