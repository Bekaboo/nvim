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

pcall(require, 'load.packer_compiled')
pcall(require, 'load.extra')

return require('packer').startup({
  function(use)
    use(require('plugin-specs.packer'))             -- Packer manages itself

    -- Color schemes
    use(require('plugin-specs.falcon'))
    use(require('plugin-specs.nvim-falcon'))
    use(require('plugin-specs.dracula'))

    -- Editing
    use(require('plugin-specs.nvim-cmp'))           -- Auto completion
    use(require('plugin-specs.vsc-vim-easymotion')) -- Easymotion for vscode-neovim
    use(require('plugin-specs.vim-surround'))
    use(require('plugin-specs.vim-commentary'))
    use(require('plugin-specs.vim-sleuth'))         -- Auto detect indentation
    use(require('plugin-specs.nvim-autopairs'))
    use(require('plugin-specs.undotree'))           -- Visible undo history
    use(require('plugin-specs.ZFVimIM'))            -- Chinese insert method

    -- Language support
    use(require('plugin-specs.nvim-lspconfig'))     -- LSP config helper
    use(require('plugin-specs.nvim-lsp-installer'))
    use(require('plugin-specs.nvim-treesitter'))    -- Language parser
    use(require('plugin-specs.copilot'))            -- Github copilot

    -- Integration
    use(require('plugin-specs.toggleterm'))         -- Better terminal integration
    use(require('plugin-specs.gitsigns'))           -- Show git info at side
    use(require('plugin-specs.lualine'))

    -- Navigation
    use(require('plugin-specs.alpha-nvim'))         -- Greeting page
    use(require('plugin-specs.nvim-tree'))          -- File tree
    use(require('plugin-specs.barbar'))             -- Buffer line
    use(require('plugin-specs.telescope'))          -- Fuzzy finding
    use(require('plugin-specs.aerial'))             -- Code outline

    -- Notes and docs
    use(require('plugin-specs.markdown-preview'))
    use(require('plugin-specs.neorg'))              -- Org-mode in nvim

    -- Tools
    use(require('plugin-specs.impatient'))          -- Speed up lua `require()`
    use(require('plugin-specs.nvim-colorizer'))     -- Show RGB colors inline
    use(require('plugin-specs.firenvim'))
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
      working_sym = '',
      error_sym = '',
      done_sym = '',
      removed_sym = '',
      moved_sym = 'ﰲ',
      keybindings = {
        toggle_info = '<Tab>'
      }
    }
  }
})
