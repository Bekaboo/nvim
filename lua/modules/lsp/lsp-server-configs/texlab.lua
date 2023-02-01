local default_config = require('modules.lsp.lsp-server-configs.default')

local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  local buf_set_option = function(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local keymaps = {
    { 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>' },
    { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>' },
    { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>' },
    { 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>' },
    { 'n', '<Leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>' },
    { 'n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>' },
    { 'n', '<Leader>wd', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>' },
    { 'n', '<Leader>wl', '<cmd>lua vim.pretty_print(vim.lsp.buf.list_workspace_folders())<CR>' },
    { 'n', '<leader>td', '<cmd>lua vim.lsp.buf.type_definition()<CR>' },
    { 'n', '<Leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>' },
    { 'n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>' },
    { 'n', '<Leader>R', '<cmd>lua vim.lsp.buf.references()<CR>' },
    { 'n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>' },
    { 'n', '[E', '<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>' },
    { 'n', ']E', '<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>' },
    { 'n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>' },
    { 'n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>' },
    { 'n', '<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>' },
    -- User VimTeX's formatting instead
    -- { 'n', '==', '<cmd>lua vim.lsp.buf.format()<CR>' },
    -- { 'x', '=', '<cmd>lua vim.lsp.buf.format()<CR>' },
  }
  for _, map in ipairs(keymaps) do
    -- use <unique> to avoid overriding telescope keymaps
    vim.cmd(string.format('silent! %snoremap <buffer> <silent> <unique> %s %s',
          unpack(map)))
  end

  -- integration with nvim-navic
  if client and client.server_capabilities
            and client.server_capabilities.documentSymbolProvider then
    local status, navic = pcall(require, 'nvim-navic')
    if status then
      navic.attach(client, bufnr)
    end
  end
end

return vim.tbl_deep_extend('force', default_config, {
  on_attach = on_attach,
})
