local M = {}

-- Jump to last accessed window on closing the current one
function M.win_close_jmp()
  -- Exclude floating windows
  if '' ~= vim.api.nvim_win_get_config(0).relative then return end
  -- Record the window we jump from (previous) and to (current)
  if nil == vim.t.winid_rec then
    vim.t.winid_rec = {
      prev = vim.fn.win_getid(),
      current = vim.fn.win_getid(),
    }
  else
    vim.t.winid_rec = {
      prev = vim.t.winid_rec.current,
      current = vim.fn.win_getid(),
    }
  end
  -- Loop through all windows to check if the previous one has been closed
  for winnr = 1, vim.fn.winnr('$') do
    if vim.fn.win_getid(winnr) == vim.t.winid_rec.prev then
      return -- Return if previous window is not closed
    end
  end
  vim.cmd('wincmd p')
end

-- Last-position-jump
-- Source: https://www.reddit.com/r/neovim/comments/ucgxmj/comment/i6coai3/?utm_source=share&utm_medium=web2x&context=3
function M.last_pos_jmp()
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
function M.close_all_floatings(key)
  local count = 0
  local current_win = vim.api.nvim_get_current_win()
  -- close current win only if it's a floating window
  if vim.api.nvim_win_get_config(current_win).relative ~= '' then
    vim.api.nvim_win_close(current_win, true)
    return
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    -- close floating windows that can be focused
    if config.relative ~= '' and config.focusable then
      vim.api.nvim_win_close(win, false) -- do not force
      count = count + 1
    end
  end
  if count == 0 and key then  -- Fallback
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(key, true, true, true), 'n', false)
  end
end

function M.git_dir(path)
  path = path and vim.fn.fnamemodify(path, ':p') or vim.fn.expand('%:p:h')
  local gitdir = vim.fn.system(string.format(
    'git -C %s rev-parse --show-toplevel', path))
  local isgitdir = vim.fn.matchstr(gitdir, '^fatal:.*') == ''
  if not isgitdir then return end
  return vim.trim(gitdir)
end

function M.proj_dir(path)
  if vim.bo.buftype ~= '' or
      '' ~= vim.api.nvim_win_get_config(0).relative then
    return
  end
  path = path and vim.fn.fnamemodify(path, ':p') or vim.fn.expand('%:p:h')
  local target_dir = M.git_dir(path)
  if not target_dir then
    target_dir = vim.fn.fnamemodify(vim.fs.find({
      '.svn',
      '.bzr',
      '.hg',
      '.project',
      '.pro',
      '.sln',
      '.vcxproj',
      '.editorconfig',
    }, { path = path, upward=true })[1] or vim.fn.expand('%'), ':p:h')
  end
  if target_dir and vim.fn.isdirectory(target_dir) ~= 0 then
    return target_dir
  end
end

function M.autocd(path)
  local target_dir = M.proj_dir(path)
  if target_dir then
    vim.cmd('cd | lcd ' .. target_dir)
  end
end

return M
