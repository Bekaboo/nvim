local lsp = require('utils.lsp')

-- Prefer biome over prettier as formatter
local formatter = lsp.start({
  cmd = { 'biome', 'lsp-proxy' },
  root_patterns = {
    'biome.json',
    'biome.jsonc',
  },
})

if not formatter then
  local prettier_cmd = vim.fn.executable('prettier_d') == 1 and 'prettier_d'
    or vim.fn.executable('prettierd') == 1 and 'prettierd'
    or vim.fn.executable('prettier') == 1 and 'prettier'

  if prettier_cmd then
    local prettier_root_patterns = {
      'prettier.config.js',
      'prettier.config.mjs',
      'prettier.config.cjs',
      '.prettierrc',
      '.prettierrc.js',
      '.prettierrc.mjs',
      '.prettierrc.cjs',
      '.prettierrc.json',
      '.prettierrc.hjson',
      '.prettierrc.json5',
      '.prettierrc.toml',
      '.prettierrc.yaml',
      '.prettierrc.yml',
      'package.json',
    }

    local prettier_lang_settings = {
      {
        formatCommand = prettier_cmd
          .. ' --stdin-filepath ${INPUT} ${--range-start=charStart} ${--range-end=charEnd} ${--tab-width=tabWidth} ${--use-tabs=!insertSpaces}',
        formatCanRange = true,
        formatStdin = true,
        rootMarkers = prettier_root_patterns,
      },
    }

    formatter = lsp.start({
      cmd = { 'efm-langserver' },
      name = 'efm-formatter-' .. prettier_cmd,
      root_patterns = prettier_root_patterns,
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      settings = {
        languages = {
          -- Setup both js & ts since this file is used for both
          javascript = prettier_lang_settings,
          typescript = prettier_lang_settings,
        },
      },
    })
  end
end

---@param client vim.lsp.Client
local function disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

local eslint_cmd = vim.fn.executable('eslint_d') == 1 and 'eslint_d'
  or vim.fn.executable('eslintd') == 1 and 'eslintd'
  or vim.fn.executable('eslint') == 1 and 'eslint'

if eslint_cmd then
  local eslint_root_patterns = {
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yml',
    '.eslintrc.yaml',
    '.eslintrc.json',
  }

  local eslint_lang_settings = {
    {
      formatCommand = eslint_cmd == 'eslint' and 'eslint --fix ${INPUT}'
        or eslint_cmd .. ' --fix-to-stdout --stdin --stdin-filename ${INPUT}',
      formatStdin = true,
      lintCommand = eslint_cmd
        .. ' --no-color --format visualstudio --stdin --stdin-filename ${INPUT}',
      lintFormats = {
        '%f(%l,%c): %trror : %m',
        '%f(%l,%c): %tarning : %m',
      },
      lintSource = eslint_cmd,
      lintStdin = true,
      lintIgnoreExitCode = true,
      rootMarkers = eslint_root_patterns,
    },
  }

  local eslint = lsp.start({
    cmd = { 'efm-langserver' },
    name = string.format(
      'efm-linter%s-%s',
      formatter and '' or '&formatter',
      eslint_cmd
    ),
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
    },
    on_attach = formatter and disable_formatting,
    root_patterns = eslint_root_patterns,
    settings = {
      languages = {
        javascript = eslint_lang_settings,
        typescript = eslint_lang_settings,
      },
    },
  })

  formatter = formatter or eslint
end

lsp.start({
  cmd = { 'typescript-language-server', '--stdio' },
  root_patterns = {
    'tsconfig.json',
    'jsconfig.json',
    'package.json',
  },
  on_attach = formatter and disable_formatting,
})
