local configs = require('plugin.winbar.configs')
local bar = require('plugin.winbar.bar')

---Get icon and icon highlight group of a path
---@param path string
---@return string icon
---@return string? icon_hl
local function get_icon(path)
  local icon_kind_opts = configs.opts.icons.kinds
  local stat = vim.uv.fs_stat(path)

  if stat and stat.type == 'directory' then
    return icon_kind_opts.symbols.Folder, 'WinBarIconKindFolder'
  end

  local file_icon = icon_kind_opts.symbols.File
  local file_icon_hl = 'WinBarIconKindFile'
  if not stat or not icon_kind_opts.use_devicons then
    return file_icon, file_icon_hl
  end

  local devicons_ok, devicons = pcall(require, 'nvim-web-devicons')
  if not devicons_ok then
    return file_icon, file_icon_hl
  end

  -- Try to find icon using the filename, explicitly disable the
  -- default icon so that we can try to find the icon using the
  -- filetype if the filename does not have a corresponding icon
  local devicon, devicon_hl = devicons.get_icon(
    vim.fs.basename(path),
    vim.fn.fnamemodify(path, ':e'),
    { default = false }
  )

  -- No corresponding devicon found using the filename, try finding icon
  -- with filetype if the file is loaded as a buf in nvim
  if not devicon then
    ---@type integer?
    local buf = vim.iter(vim.api.nvim_list_bufs()):find(function(buf)
      return vim.api.nvim_buf_get_name(buf) == path
    end)
    if buf then
      local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })
      devicon, devicon_hl = devicons.get_icon_by_filetype(filetype)
    end
  end

  file_icon = devicon and devicon .. ' ' or file_icon
  file_icon_hl = devicon_hl

  return file_icon, file_icon_hl
end

---Convert a path into a winbar symbol
---@param path string full path
---@param buf integer buffer handler
---@param win integer window handler
---@return winbar_symbol_t
local function convert(path, buf, win)
  local path_opts = configs.opts.sources.path
  local icon, icon_hl = get_icon(path)
  return bar.winbar_symbol_t:new(setmetatable({
    buf = buf,
    win = win,
    name = vim.fs.basename(path),
    icon = icon,
    icon_hl = icon_hl,
    ---Override the default jump function
    jump = function(_)
      vim.cmd.edit(path)
    end,
  }, {
    ---@param self winbar_symbol_t
    __index = function(self, k)
      if k == 'children' then
        self.children = {}
        for name in vim.fs.dir(path) do
          if path_opts.filter(name) then
            table.insert(
              self.children,
              convert(vim.fs.joinpath(path, name), buf, win)
            )
          end
        end
        return self.children
      end
      if k == 'siblings' or k == 'sibling_idx' then
        local parent_dir = vim.fs.dirname(path)
        self.siblings = {}
        self.sibling_idx = 1
        for idx, name in vim.iter(vim.fs.dir(parent_dir)):enumerate() do
          if path_opts.filter(name) then
            table.insert(
              self.siblings,
              convert(vim.fs.joinpath(parent_dir, name), buf, win)
            )
            if name == self.name then
              self.sibling_idx = idx
            end
          end
        end
        return self[k]
      end
    end,
  }))
end

local normalize = vim.fs.normalize
if vim.uv.os_uname().sysname:find('Windows', 1, true) then
  ---Normalize path on Windows,
  ---see https://github.com/Bekaboo/dropbar.nvim/issues/174
  ---In addition to normalizing the path with `vim.fs.normalize()`, we convert
  ---the drive letter to uppercase.
  ---This is a workaround for the issue that the path is case-insensitive on
  ---Windows, as a result `vim.api.nvim_buf_get_name()` and `vim.fn.getcwd()`
  ---can return the same drive letter with different cases, e.g. 'C:' and 'c:'.
  ---To standardize this, we convert the drive letter to uppercase.
  ---@param path string full path
  ---@return string: path with uppercase drive letter
  function normalize(path)
    return (
      string.gsub(vim.fs.normalize(path), '^([a-zA-Z]):', function(c)
        return c:upper() .. ':'
      end)
    )
  end
end

---Get list of winbar symbols of the parent directories of given buffer
---@param buf integer buffer handler
---@param win integer window handler
---@param _ integer[] cursor position, ignored
---@return winbar_symbol_t[] winbar symbols
local function get_symbols(buf, win, _)
  local path_opts = configs.opts.sources.path
  local symbols = {} ---@type winbar_symbol_t[]
  local current_path = normalize((vim.api.nvim_buf_get_name(buf)))
  local root =
    normalize(configs.eval(path_opts.relative_to, buf, win) --[[@as string]])
  while
    current_path
    and current_path ~= '.'
    and current_path ~= root
    and current_path ~= vim.fs.dirname(current_path)
  do
    table.insert(symbols, 1, convert(current_path, buf, win))
    current_path = vim.fs.dirname(current_path)
  end
  if vim.bo[buf].mod then
    symbols[#symbols] = path_opts.modified(symbols[#symbols])
  end
  return symbols
end

return {
  get_symbols = get_symbols,
}
