local cmd = vim.cmd
local api = vim.api
local fn = vim.fn
local default_root = fn.stdpath('data') .. '/site'
local packer = nil

local packer_info = {
  modules = {},
  root = default_root,
  bootstrap = {
    path = default_root .. '/pack/packer/opt/packer.nvim',
    url = 'https://github.com/Bekaboo/packer.nvim',
  },
  config = {
    snapshot = {
      auto = true,
      name = function()
        return string.format('lock_%s.json', os.date('%Y-%m-%d'))
      end,
      path = fn.stdpath('config') .. '/lockfiles',
      silent_overwrite = true,
    },
    compile_path = default_root .. '/lua/packer_compiled.lua',
    opt_default = false,
    transitive_opt = true,
  },
}

local function update_paths()
  if packer_info.root ~= default_root then
    local root = packer_info.root
    packer_info.bootstrap.path = root .. '/pack/packer/opt/packer.nvim'
    packer_info.config.package_root = root .. '/pack'
    packer_info.config.compile_path = root .. '/lua/packer_compiled.lua'
    vim.opt.rtp:remove(default_root)
    vim.opt.pp:remove(default_root)
    vim.opt.rtp:append(root)
    vim.opt.pp:append(root)
  end
end

local function register_plugins()
  -- packer.nvim manages itself
  packer.use({ 'Bekaboo/packer.nvim', opt = true })
  -- manage other plugins
  for _, module in ipairs(packer_info.modules) do
    local specs = require(string.format('modules.%s', module))
    for _, spec in pairs(specs) do
      packer.use(spec)
    end
  end
end

local function load_packer()
  if not packer then
    cmd('packadd packer.nvim')
    packer = require('packer')
    packer.init(packer_info.config)
    register_plugins()
  end
end

local function sync_plugins()
  load_packer()
  -- make directory for packer compiled file
  os.execute(string.format('mkdir -p %s',
    fn.fnamemodify(packer_info.config.compile_path, ':p:h')))
  packer.sync()
end

-- Install and add packer.nvim if not installed
local function bootstrap()
  local boot = packer_info.bootstrap
  local compile_path = packer_info.config.compile_path
  -- Install packer if not already installed
  if fn.empty(fn.glob(boot.path)) > 0 then
    vim.notify('Installing packer.nvim...', vim.log.levels.INFO)
    fn.system({ 'git', 'clone', '--depth', '1', boot.url, boot.path })
    vim.notify('packer.nvim cloned to ' .. boot.path, vim.log.levels.INFO)
    -- use packer to sync other plugins
    sync_plugins()
    return true
  end
  -- Sync plugins if packer is installed but compiled file is lost
  if fn.filereadable(compile_path) == 0 then
    vim.notify(string.format('Compiling at %s', compile_path))
    sync_plugins()
    return true
  end
  return false
end

local function load_packer_compiled()
  local fname = fn.fnamemodify(packer_info.config.compile_path, ':t:r')
  local ok, err_msg = pcall(require, fname)
  if not ok then
    vim.notify(string.format('Error loading packer compiled file %s: %s',
      fname, err_msg), vim.log.levels.ERROR)
  end
end

local function create_packer_usercmds()

  local function nilify(tbl)
    if type(tbl) == 'table' and not next(tbl) then
      return nil
    end
    return tbl
  end

  local packer_cmds = {
    Clean = { opts = { nargs = 0 }, func = function(tbl) require('packer').snapshot(tbl.args) end },
    Compile = { opts = { nargs = '*', complete = function(...) load_packer() return require('packer').plugin_complete(...) end }, func = function(tbl) require('packer').compile(tbl.args) end },
    Install = { opts = { nargs = '*', complete = function(...) load_packer() return require('packer').plugin_complete(...) end }, func = function(tbl) require('packer').install(nilify(tbl.fargs)) end, },
    Load = { opts = { nargs = '+', bang = true, complete = function(...) load_packer() return require('packer').loader_complete(...) end }, func = function(tbl) require('packer').loader(tbl.args) end },
    Profile = { opts = { nargs = 0 }, func = function(_) require('packer').profile_output() end },
    Snapshot = { opts = { nargs = '*', complete = function(...) load_packer() return require('packer.snapshot').completion.create(...) end }, func = function(tbl) require('packer').snapshot(tbl.args) end },
    SnapshotDelete = { opts = { nargs = '+', complete = function(...) load_packer() return require('packer.snapshot').completion.snapshot(...) end }, func = function(tbl) require('packer.snapshot').delete(tbl.args) end },
    SnapshotRollback = { opts = { nargs = '+', complete = function(...) load_packer() return require('packer.snapshot').completion.rollback(...) end }, func = function(tbl) require('packer').rollback(tbl.args) end },
    Status = { opts = { nargs = 0 }, func = function(_) require('packer').status() end },
    Sync = { opts = { nargs = '*', complete = function(...) load_packer() return require('packer').plugin_complete(...) end }, func = function(tbl) require('packer').sync(nilify(tbl.fargs)) end },
    Update = { opts = { nargs = '*', complete = function(...) load_packer() return require('packer').plugin_complete(...) end }, func = function(tbl) require('packer').update(nilify(tbl.fargs)) end },
  }

  for packer_cmd, attr in pairs(packer_cmds) do
    api.nvim_create_user_command('Packer' .. packer_cmd, function(tbl)
      -- load packer if not loaded
      load_packer()
      -- then call the corresponding function with args
      attr.func(tbl)
    end, attr.opts)
  end

  -- a handy abbreviation for PackerSync and PackerCompile
  vim.cmd('cnoreabbrev pks PackerSync')
  vim.cmd('cnoreabbrev pkc PackerCompile')
end

local function create_packer_autocmds()
  api.nvim_create_autocmd('User', {
    pattern = {
      'PackerSyncComplete',
      'PackerUpdateComplete',
      'PackerCleanComplete',
      'PackerInstallComplete',
    },
    callback = function()
      local snapshots =
          fn.glob(packer_info.config.snapshot.path .. '/*', false, true)
        local i = 1
        while i <= #snapshots - 7 do
          os.remove(snapshots[i])
          table.remove(snapshots, i)
          i = i + 1
        end
    end,
  })
end

local function manage_plugins(info)
  packer_info = vim.tbl_deep_extend('force', packer_info, info)
  update_paths()
  if not bootstrap() then
    load_packer_compiled()
    create_packer_usercmds()
    create_packer_autocmds()
  end
end

return {
  manage_plugins = manage_plugins,
}
