-- Bootstrap packer.nvim if not installed
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_url = 'https://github.com/wbthomason/packer.nvim'
local execute = vim.cmd
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system ({
      'git', 'clone', '--depth', '1', packer_url, install_path
    })
    print 'Installing packer.nvim and reopen Neovim...'
    execute 'packadd packer.nvim'
end

-- `PackerSync` on save of `plugins.lua`
-- vim.cmd [[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]]

require('load.packer_compiled')
pcall(require, 'load.extra')

local get = require('utils.get')
return require('packer').startup({
  function(use)
    use(get.spec('packer'))             -- Packer manages itself

    -- Color schemes
    use(get.spec('falcon'))
    use(get.spec('dracula'))

    -- Editing
    use(get.spec('nvim-cmp'))           -- Auto completion
    use(get.spec('vsc-vim-easymotion')) -- Easymotion for vscode-neovim
    use(get.spec('vim-surround'))
    use(get.spec('vim-commentary'))
    use(get.spec('vim-sleuth'))         -- Auto detect indentation
    use(get.spec('nvim-autopairs'))
    use(get.spec('undotree'))           -- Visible undo history

    -- Language support
    use(get.spec('nvim-lspconfig'))     -- LSP config helper
    use(get.spec('nvim-lsp-installer'))
    use(get.spec('nvim-treesitter'))    -- Language parser
    use(get.spec('copilot'))            -- Github copilot

    -- Integration
    use(get.spec('toggleterm'))         -- Better terminal integration
    use(get.spec('gitsigns'))           -- Show git info at side
    use(get.spec('lualine'))

    -- Navigation
    use(get.spec('alpha-nvim'))         -- Greeting page
    use(get.spec('nvim-tree'))          -- File tree
    use(get.spec('barbar'))             -- Buffer line
    use(get.spec('telescope'))          -- Fuzzy finding
    use(get.spec('aerial'))             -- Code outline

    -- Notes and docs
    use(get.spec('markdown-preview'))

    -- Tools
    use(get.spec('impatient'))          -- Speed up lua `require()`
    use(get.spec('nvim-colorizer'))     -- Show RGB colors inline
  end,

  config = {
    clone_timeout = 300,
    compile_path = fn.stdpath('config') .. '/lua/load/packer_compiled.lua',
    opt_default = false,
    transitive_opt = true,
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'double' })
      end,
      working_sym = '???',
      error_sym = '???',
      done_sym = '???',
      removed_sym = '???',
      moved_sym = '???',
      keybindings = {
        toggle_info = '<Tab>'
      }
    }
  }
})
