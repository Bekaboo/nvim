local M = {}

M['vimtex'] = function()
  vim.g.vimtex_format_enabled = 1
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
      vim.api.nvim_eval('vimtex#init()')
      vim.api.nvim_eval('vimtex#text_obj#init_buffer()')
    end
  })
end

M['clipboard-image.nvim'] = function()

  local function empty_line(lnum)
    return vim.fn.match(vim.api.nvim_buf_get_lines(
      0, lnum - 1, lnum, false)[1], '^\\s*$') == 0
  end

  require('clipboard-image').setup({
    -- Default configuration for all filetype
    default = {
      img_dir = { '%:p:h', 'pic', '%:p:t:r' },
      img_dir_txt = function()
        return 'pic/' .. vim.fn.expand('%:p:t:r')
      end,
      img_name = function()
        vim.fn.inputsave()
        local name = vim.fn.input('Name: ')
        vim.fn.inputrestore()
        if name == nil or name == '' then
          return os.date('%y-%m-%d-%H-%M-%S')
        end
        return name
      end,
    },
    markdown = {
      affix = [[![](%s)]],
      img_handler = function(img)
        vim.cmd('normal! 0f[')            -- find the first '['
        vim.cmd('normal! a' .. img.name)  -- then put the name into the brackets

        local y = vim.api.nvim_win_get_cursor(0)[1]
        local n_lines = vim.api.nvim_buf_line_count(0)
        if y - 1 > 0 and not empty_line(y - 1)  then
          vim.cmd('normal! O')            -- add an empty line above
          vim.cmd('normal! j')
        end
        if y + 1 <= n_lines and not empty_line(y + 1) then
          vim.cmd('normal! o')            -- add an empty line below
          vim.cmd('normal! k')
        end

        -- Indent image line according to indentation of its context
        -- TODO: use treesitter to get current indent?
        y = vim.api.nvim_win_get_cursor(0)[1]
        local offset = 0
        local context_indent = -1
        local current_indent = vim.fn.indent(y)
        while context_indent == -1
              and y - offset > 0 and y + offset <= n_lines do
          offset = offset + 1
          if not empty_line(y - offset) then
            context_indent = vim.fn.indent(y - offset)
          end
          if not empty_line(y + offset)
              and vim.fn.indent(y + offset) > context_indent then
            context_indent = vim.fn.indent(y + offset)
          end
        end
        if context_indent == -1 then return end
        local n_shifts
        if vim.bo.sw > 0 then
           n_shifts = math.ceil((context_indent - current_indent) / vim.bo.sw)
        else
           n_shifts = math.ceil((context_indent - current_indent) / vim.bo.ts)
        end
        if n_shifts > 0 then
          while n_shifts > 0 do
            vim.cmd('normal! >>')
            n_shifts = n_shifts - 1
          end
        elseif n_shifts < 0 then
          while n_shifts < 0 do
            vim.cmd('normal! <<')
            n_shifts = n_shifts + 1
          end
        end

        vim.cmd('normal! j')
      end
    }
  })
end

return M
