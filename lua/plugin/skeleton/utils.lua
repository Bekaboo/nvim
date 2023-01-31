local M = {}
local fn = vim.fn
local api = vim.api
local uv = vim.loop
local config = require('plugin.skeleton.config').config

M.trigger_info = {}

---Select a non-empty skeleton file from a list of candidates.
---@param skeletons string[] list of names of skeleton files
---@param skeldir string directory where the skeleton file is located
---@return string|boolean skeleton file path or false if no skeleton is found
function M.select_skel(skeletons, skeldir)
  for _, skeleton in ipairs(skeletons) do
    local stat = uv.fs_stat(skeldir .. '/' .. skeleton)
    if stat and stat.type == 'file' and stat.size > 0 then
      return skeldir .. '/' .. skeleton
    end
  end

  return false
end

---Find a proper skeleton file inside skeleton directory.
---@param ft string filetype of the new file
---@param fname string name of the new file
---@param skeldir string skeleton directory, default to <project_dir>/.skeleton
---@param fallback string[] list of skeleton filenames
---@return boolean|string skeleton file path or false if no skeleton is found
function M.fallback_skeldir(ft, fname, skeldir, fallback)
  if not skeldir or fn.isdirectory(skeldir) == 0 then
    return false
  end

  local skeleton = M.select_skel(fallback, skeldir)

  local ext = ft ~= '' and ft or fn.fnamemodify(fname, ':e')
  local skeleton_sub_dir = skeldir .. '/' .. ext
  if not skeleton and fn.isdirectory(skeleton_sub_dir) == 1 then
    skeleton = M.select_skel(fallback, skeleton_sub_dir)
  end

  if type(skeleton) == 'string' and fn.filereadable(skeleton) == 1 then
    return skeleton
  end

  return false
end

---Find a proper skeleton file in project directory.
---@param skeldir string skeleton directory
---@param fallback string[] list of skeleton filenames
---@return boolean|string skeleton file path or false if no skeleton is found
function M.fallback_bare(skeldir, fallback)
  if not skeldir or fn.isdirectory(skeldir) == 0 then
    return false
  end

  local skeleton = M.select_skel(fallback, skeldir)
  if type(skeleton) == 'string' and fn.filereadable(skeleton) == 1 then
    return skeleton
  end

  return false
end

---Check if the file is new.
---@return boolean true if the file is new
function M.is_new_file(event)
  if event == 'BufNewFile' then
    return true
  end
  return false
end

---Check if the file is empty.
---@param fpath string path to the file
---@boolean true if the file is empty
function M.is_empty_file(fpath)
  local stat = uv.fs_stat(fpath)
  if stat and stat.type == 'file' and stat.size == 0 then
    return true
  end
  return false
end

---Check if the new file is configured in the setup function.
---@return boolean, any
function M.configured()

  local fpath = fn.fnamemodify(M.trigger_info.file, ':p')
  local ft = api.nvim_buf_get_option(M.trigger_info.buf, 'filetype')

  if vim.tbl_isempty(config.rules or {})
    or vim.tbl_isempty(config.rules[ft] or {})
  then
    return false
  end

  for pattern, configure in pairs(config.rules[ft]) do
    if fpath:match(pattern) then
      return true, configure
    end
  end

  return false
end

---Write skeleton to the file.
---@param skeleton string|function|boolean
---@return boolean false if skeleton is not applied
function M.write(skeleton)
  if api.nvim_buf_get_lines(M.trigger_info.buf, 0, -1, false)[1] ~= '' then
    return false
  end

  if type(skeleton) == 'function' then
    skeleton = skeleton(M.fallback)
  end
  if type(skeleton) == 'string' then
    vim.cmd('silent! 0r ' .. vim.fn.fnamemodify(skeleton, ':p'))
    return true
  end

  return false
end

---Find proper skeleton file in predifined directories.
---@param fallback_list nil|string[] list of skeleton files
---@return string|boolean skeleton file path or false if no skeleton is found
function M.fallback(fallback_list)
  local fname = fn.fnamemodify(M.trigger_info.file, ':t')
  local fpath = fn.fnamemodify(M.trigger_info.file, ':p:h')
  local ft = api.nvim_buf_get_option(M.trigger_info.buf, 'filetype')
  local proj_dir = require('utils.funcs').proj_dir(M.trigger_info.file) or ''

  local default_fallback = {
    fname .. '.skel',
    '.' .. fname .. '.skel',
    ft .. '.skel',
    '.' .. ft .. '.skel',
  }
  fallback_list = fallback_list or default_fallback

  return M.fallback_bare(fpath, fallback_list)
    or M.fallback_skeldir(ft, fname, fpath .. '/' .. config.proj_skeldir, fallback_list)
    or M.fallback_bare(proj_dir, fallback_list)
    or M.fallback_skeldir(ft, fname, proj_dir .. '/' .. config.proj_skeldir, fallback_list)
    or M.fallback_skeldir(ft, fname, config.skeldir, fallback_list)
end

---Try applying a skeleton to the new file.
---@return boolean true if skeleton is applied
function M.apply(tbl)
  if not vim.bo.buftype == '' then
    return false
  end

  M.trigger_info = tbl
  local fname = fn.fnamemodify(M.trigger_info.file, ':t')
  local ft = api.nvim_buf_get_option(M.trigger_info.buf, 'filetype')
  if ft == '' then ft = fn.fnamemodify(fname, ':e') end

  if config.apply.new_files and M.is_new_file(tbl.event) or
      config.apply.empty_files and M.is_empty_file(tbl.file) then
    local configured, configure = M.configured()
    if configured then
      return M.write(configure)
    else
      return M.write(M.fallback())
    end
  end

  return false
end

return M
