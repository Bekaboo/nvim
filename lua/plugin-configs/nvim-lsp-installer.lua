local M = {}

M.langs = require('utils.shared').langs
M.ensure_installed = require('utils.shared').langs:list('lsp_server')
M.lsp_installer = require('nvim-lsp-installer')

--------------------------------------------------------------------------------
-- LSP UI configs --------------------------------------------------------------

-- Config for `nvim-lsp-installer` icons
M.lsp_installer_opts = {
  ui = {
    icons = {
      server_installed = '',
      server_pending = '',
      server_uninstalled = ''
    },
    keymaps = {
      toggle_server_expand = '<Tab>',
      install_server = '<CR>',
      update_server = 's',
      update_all_servers = 'S',
      uninstall_server = 'dd'
    }
  }
}
M.lsp_installer.settings(M.lsp_installer_opts)

-- Customize LSP floating window border
M.floating_preview_opts = { border = 'single' }
M.floating_preview_setup = function(custom_opts)
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = vim.tbl_deep_extend('force', opts, custom_opts)
    vim.pretty_print(opts)
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end
end
M.floating_preview_setup(M.floating_preview_opts)

-- LSP diagnostic signs
M.diagnostic_opts = {}
M.diagnostic_opts.signs = {
  { 'DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError', numhl = 'DiagnosticSignError' } },
  { 'DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn', numhl = 'DiagnosticSignWarn' } },
  { 'DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo', numhl = 'DiagnosticSignInfo' } },
  { 'DiagnosticSignHint', { text = ' ', texthl = 'DiagnosticSignHint', numhl = 'DiagnosticSignHint' } },
}
for _, sign_settings in ipairs(M.diagnostic_opts.signs) do
  vim.fn.sign_define(unpack(sign_settings))
end

M.diagnostic_opts.handlers = {
  -- Enable underline, use default values
  underline = true,
  -- Enable virtual text, override spacing to 4
  virtual_text = {
    spacing = 4,
    prefix = ''
  }
}
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  M.diagnostic_opts.handlers)

-- Show diagnostics automatically in hover
-- vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- -- Goto definition in split window
-- local function goto_definition(split_cmd)
--   local util = vim.lsp.util
--   local log = require('vim.lsp.log')
--   local api = vim.api
--   -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
--   local handler = function(_, result, ctx)
--     if result == nil or vim.tbl_isempty(result) then
--       local _ = log.info() and log.info(ctx.method, 'No location found')
--       return nil
--     end
--     if split_cmd then
--       vim.cmd(split_cmd)
--     end
--     if vim.tbl_islist(result) then
--       util.jump_to_location(result[1])
--       if #result > 1 then
--         util.set_qflist(util.locations_to_items(result))
--         api.nvim_command('copen')
--         api.nvim_command('wincmd p')
--       end
--     else
--       util.jump_to_location(result)
--     end
--   end
--   return handler
-- end
-- vim.lsp.handlers['textDocument/definition'] = goto_definition('vsplit')

-- End of LSP UI configs -------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Pass config table to each LSP server: ---------------------------------------

-------------------------- on_attach function begins ---------------------------
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.keymaps = {
  { 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true } },
  { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true } },
  { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true } },
  { 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true } },
  { 'n', '<Leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true } },
  { 'n', '<Leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { noremap = true, silent = true } },
  { 'n', '<Leader>lwd', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { noremap = true, silent = true } },
  { 'n', '<Leader>lwl', '<cmd>lua vim.pretty_print(vim.lsp.buf.list_workspace_folders())<CR>',
    { noremap = true, silent = true } },
  { 'n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true } },
  { 'n', '<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true } },
  { 'n', '<Leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true } },
  { 'n', '<Leader>lR', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true } },
  { 'n', '<Leader>le', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true } },
  { 'n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true } },
  { 'n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true } },
  { 'n', '<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true } },
  { 'n', '<leader>l=', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true } },
}

M.on_attach = function(client, bufnr)
  local buf_set_keymap = function(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local buf_set_option = function(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  for _, map in ipairs(M.keymaps) do
    buf_set_keymap(unpack(map))
  end
end
--------------------------- on_attach function ends ----------------------------

-- Add additional capabilities supported by nvim-cmp
M.capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ready, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ready then
  M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)
end

M.get_lsp_server_cfg = function(name)
  local status, server_config =
  pcall(require, 'lsp-server-configs/' .. name)
  if not status then return {}
  else return server_config
  end
end

-- Automatically install servers in `ensure_installed`
-- and add additional capabilities supported by nvim-cmp
M.lsp_install_and_set = function()
  for _, server_name in pairs(M.ensure_installed) do
    local server_available, requested_server = M.lsp_installer.get_server(server_name)
    if server_available then
      if not requested_server:is_installed() then
        print('[lsp-installer]: installing ' .. server_name)
        requested_server:install()
      end
      requested_server:on_ready(function()
        requested_server:setup {
          on_attach = M.on_attach,
          capabilities = M.capabilities,
          settings = M.get_lsp_server_cfg(server_name)
        }
      end)
    else
      print('[lsp-installer]: server ' .. server_name .. ' not available')
    end
  end
end
M.lsp_install_and_set()
-- Passed config table to each LSP server --------------------------------------
--------------------------------------------------------------------------------

return M
