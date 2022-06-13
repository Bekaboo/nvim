local M = {}

-- Jump to last accessed window on closing the current one
M.win_close_jmp = function()
  -- Exclude floating windows
  if '' ~= vim.api.nvim_win_get_config(0).relative then return end
  -- Record the window we jump from (previous) and to (current)
  if nil == vim.t.winid_rec then
    vim.t.winid_rec = { prev = vim.fn.win_getid(), current = vim.fn.win_getid() }
  else
    vim.t.winid_rec = { prev = vim.t.winid_rec.current, current = vim.fn.win_getid() }
  end
  -- Loop through all windows to check if the previous one has been closed
  for winnr = 1, vim.fn.winnr('$') do
    if vim.fn.win_getid(winnr) == vim.t.winid_rec.prev then
      return -- Return if previous window is not closed
    end
  end
  vim.cmd [[ wincmd p ]]
end

-- Last-position-jump
-- Source: https://www.reddit.com/r/neovim/comments/ucgxmj/comment/i6coai3/?utm_source=share&utm_medium=web2x&context=3
M.last_pos_jmp = function()
  local ft = vim.opt_local.filetype:get()
  -- don't apply to git messages
  if (ft:match('commit') or ft:match('rebase')) then
    return
  end
  -- get position of last saved edit
  local markpos = vim.api.nvim_buf_get_mark(0, '"')
  local line = markpos[1]
  local col = markpos[2]
  -- if in range, go there
  if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
    vim.api.nvim_win_set_cursor(0, { line, col })
  end
end

-- Source: https://github.com/wookayin/dotfiles/commit/96d935515486f44ec361db3df8ab9ebb41ea7e40
M.close_all_floatings = function(key)
  local count = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then -- is_floating_window?
      vim.api.nvim_win_close(win, false) -- do not force
      count = count + 1
    end
  end
  if count == 0 then  -- Fallback
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(key, true, true, true), 'nt', true)
  end
end

-- Judge if a plugin is loaded
M.loaded = function(plugin)
  return packer_plugins[plugin] and packer_plugins[plugin].loaded
end

return M
