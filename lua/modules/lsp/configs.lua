local M = {}

M['nvim-lspconfig'] = function()
  local static = require('utils.static')
  local ensure_installed = static.langs:list('lsp_server')
  local icons = static.icons

  local function lspconfig_setui()
    -- Customize LSP floating window border
    local floating_preview_opts = { border = 'single' }
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = vim.tbl_deep_extend('force', opts, floating_preview_opts)
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end
    local diagnostic_opts = {}
    -- LSP diagnostic signs
    diagnostic_opts.signs = {
      { 'DiagnosticSignError', { text = icons.DiagnosticSignError, texthl = 'DiagnosticSignError', numhl = 'DiagnosticSignError' } },
      { 'DiagnosticSignWarn', { text = icons.DiagnosticSignWarn, texthl = 'DiagnosticSignWarn', numhl = 'DiagnosticSignWarn' } },
      { 'DiagnosticSignInfo', { text = icons.DiagnosticSignInfo, texthl = 'DiagnosticSignInfo', numhl = 'DiagnosticSignInfo' } },
      { 'DiagnosticSignHint', { text = icons.DiagnosticSignHint, texthl = 'DiagnosticSignHint', numhl = 'DiagnosticSignHint' } },
    }
    for _, sign_settings in ipairs(diagnostic_opts.signs) do
      vim.fn.sign_define(unpack(sign_settings))
    end
    diagnostic_opts.handlers = {
      -- Enable underline, use default values
      underline = true,
      -- Enable virtual text, override spacing to 4
      virtual_text = {
        spacing = 4,
        prefix = ''
      },
    }
    vim.lsp.handlers['textDocument/publishDiagnostics']
        = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                       diagnostic_opts.handlers)
    -- setup LspInfo floating window border
    require('lspconfig.ui.windows').default_options.border = 'single'
    -- reload LspInfo floating window on VimResized
    vim.api.nvim_create_autocmd('VimResized', {
      pattern = '*',
      callback = function()
        if vim.bo.ft == 'lspinfo' then
          vim.api.nvim_win_close(0, true)
          vim.cmd('LspInfo')
        end
      end,
    })
  end

  local function get_server_config(server_name)
    local status, config
      = pcall(require, 'modules.lsp.lsp-server-configs.' .. server_name)
    if not status then
      return require('modules.lsp.lsp-server-configs.shared.default')
    else
      return config
    end
  end

  local function lsp_setup()
    for _, server_name in pairs(ensure_installed) do
      require('lspconfig')[server_name].setup(get_server_config(server_name))
    end
  end

  lspconfig_setui()
  lsp_setup()
end

M['clangd_extensions.nvim'] = function()
  local icons = require('utils.static').icons
  local default_config = require('modules.lsp.lsp-server-configs.shared.default')

  require('clangd_extensions').setup({
    server = default_config,
    extensions = {
      ast = {
        role_icons = {
          ['type'] = icons.Type,
          ['declaration'] = icons.Function,
          ['expression'] = icons.Snippet,
          ['specifier'] = icons.Specifier,
          ['statement'] = icons.Statement,
          ['template argument'] = icons.TypeParameter,
        },
        kind_icons = {
          ['Compound'] = icons.Namespace,
          ['Recovery'] = icons.DiagnosticSignError,
          ['TranslationUnit'] = icons.Unit,
          ['PackExpansion'] = icons.Ellipsis,
          ['TemplateTypeParm'] = icons.TypeParameter,
          ['TemplateTemplateParm'] = icons.TypeParameter,
          ['TemplateParamObject'] = icons.TypeParameter,
        },
      },
      memory_usage = {
        border = 'single',
      },
      symbol_info = {
        border = 'single',
      },
    },
  })
end

M['mason-lspconfig.nvim'] = function()
  require('mason-lspconfig').setup({
    ensure_installed = require('utils.static').langs:list('lsp_server'),
  })
end

M['aerial.nvim'] = function()
  require('aerial').setup({
    keymaps = {
      ['<M-v>'] = 'actions.jump_vsplit',
      ['<M-s>'] = 'actions.jump_split',
      ['<Tab>'] = 'actions.scroll',
      ['p'] = 'actions.prev_up',

      ['?'] = false,
      ['<C-v>'] = false,
      ['<C-s>'] = false,
      ['[['] = false,
      [']]'] = false,
      ['l'] = false,
      ['L'] = false,
      ['h'] = false,
      ['H'] = false,
    },
    attach_mode = 'window',
    backends = { 'lsp', 'markdown', 'man' },
    disable_max_lines = 8192,
    filter_kind = false,
    icons = require('utils.static').icons,
    ignore = {
      filetypes = { 'aerial', 'help', 'alpha', 'undotree', 'TelescopePrompt' },
    },
    link_folds_to_tree = false,
    link_tree_to_folds = false,
    manage_folds = false,
    layout = {
      default_direction = 'float',
      max_width = 0.5,
      min_width = 0.25,
    },
    float = {
      border = 'single',
      relative = 'editor',
      max_height = 0.7,
    },
    close_on_select = true,
    show_guides = true,
    treesitter = { update_delay = 10 },
    markdown = { update_delay = 10 },
  })
  vim.keymap.set('n', '<Leader>o', '<Cmd>AerialToggle float<CR>', { noremap = true })
  vim.keymap.set('n', '<Leader>O', '<Cmd>AerialToggle right<CR>', { noremap = true })
end

M['fidget.nvim'] = function()
  require('fidget').setup({
    text = { spinner = 'dots' },
    fmt = {
      fidget = function(fidget_name, spinner)
        if string.match(vim.api.nvim_get_mode().mode, 'i.?') then return nil end
        return string.format('%s %s', spinner, fidget_name)
      end,
      task = function(_) return nil end,
    },
  })
end

return M
