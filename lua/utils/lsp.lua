local M = {}

---@type lsp_client_config_t
---@diagnostic disable-next-line: missing-fields
M.default_config = {
  root_patterns = require('utils.fs').root_patterns,
  init_options = { hostInfo = 'neovim' },
}

---@class vim.lsp.ClientConfig: lsp_client_config_t
---@class lsp_client_config_t
---@field cmd? (string[]|fun(dispatchers: table):table)
---@field cmd_cwd? string
---@field cmd_env? (table)
---@field detached? boolean
---@field workspace_folders? (table)
---@field capabilities? lsp.ClientCapabilities
---@field handlers? table<string,function>
---@field settings? table
---@field commands? table
---@field init_options? table
---@field name? string
---@field get_language_id? fun(bufnr: integer, filetype: string): string
---@field offset_encoding? string
---@field on_error? fun(code: integer)
---@field before_init? function
---@field on_init? function
---@field on_exit? fun(code: integer, signal: integer, client_id: integer)
---@field on_attach? fun(client: vim.lsp.Client, bufnr: integer)
---@field trace? 'off'|'messages'|'verbose'|nil
---@field flags? table
---@field root_dir? string
---@field root_patterns? string[]
---@field server_configs? string[]

---Wrapper of `vim.lsp.start()`, starts and attaches LSP client for
---the current buffer
---@param config lsp_client_config_t
---@param opts table?
---@return integer? client_id id of attached client or nil if failed
function M.start(config, opts)
  if vim.b.bigfile or vim.bo.bt == 'nofile' or vim.g.vscode then
    return
  end

  local cmd_type = type(config.cmd)
  local cmd_exec = cmd_type == 'table' and config.cmd[1]
  if cmd_type == 'table' and vim.fn.executable(cmd_exec or '') == 0 then
    return
  end

  local name = cmd_exec
  local bufname = vim.api.nvim_buf_get_name(0)
  if not vim.uv.fs_stat(bufname) then
    return
  end

  -- Don't launch unconfigured servers unless `opts.launch_unconfigured` is set
  -- Use `root_patterns` as fallback of server config file patterns
  local server_configs = config.server_configs or config.root_patterns
  local server_unconfigured = server_configs
    and not vim.tbl_isempty(server_configs)
    and vim.tbl_isempty(vim.fs.find(server_configs, {
      upward = true,
      path = vim.fs.dirname(bufname),
    }))
  if server_unconfigured and not (opts and opts.launch_unconfigured) then
    return
  end

  local root_dir = vim.fn.fnamemodify(
    vim.fs.root(
      bufname,
      vim.list_extend(
        config.root_patterns or {},
        M.default_config.root_patterns or {}
      )
    ) or vim.fs.dirname(bufname),
    '%:p'
  )

  return vim.lsp.start(
    vim.tbl_deep_extend('keep', config or {}, {
      name = name,
      root_dir = root_dir,
    }, M.default_config),
    opts
  )
end

---@class lsp_soft_stop_opts_t
---@field retry integer?
---@field interval integer?
---@field on_close fun(client: vim.lsp.Client)

---Soft stop LSP client with retries
---@param client_or_id integer|vim.lsp.Client
---@param opts lsp_soft_stop_opts_t?
function M.soft_stop(client_or_id, opts)
  local client = type(client_or_id) == 'number'
      and vim.lsp.get_client_by_id(client_or_id)
    or client_or_id --[[@as vim.lsp.Client]]
  if not client then
    return
  end
  opts = opts or {}
  opts.retry = opts.retry or 4
  opts.interval = opts.interval or 500
  opts.on_close = opts.on_close or function() end

  if opts.retry <= 0 then
    client.stop(true)
    opts.on_close(client)
    return
  end
  client.stop()
  ---@diagnostic disable-next-line: invisible
  if client.is_stopped() then
    opts.on_close(client)
    return
  end
  vim.defer_fn(function()
    opts.retry = opts.retry - 1
    M.soft_stop(client, opts)
  end, opts.interval)
end

---Restart and reattach LSP client
---@param client_or_id integer|vim.lsp.Client
function M.restart(client_or_id)
  local client = type(client_or_id) == 'number'
      and vim.lsp.get_client_by_id(client_or_id)
    or client_or_id --[[@as vim.lsp.Client]]
  if not client then
    return
  end
  local config = client.config
  local attached_buffers = client.attached_buffers
  M.soft_stop(client, {
    on_close = function()
      for buf, _ in pairs(attached_buffers) do
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        vim.api.nvim_buf_call(buf, function()
          M.start(config)
        end)
      end
    end,
  })
end

return M
