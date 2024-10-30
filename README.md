# :warning: Moved to [here](https://github.com/Bekaboo/dot/tree/master/.config/nvim)

## Neovim :: M Λ C R O

[**Neovim :: M Λ C R O**](https://github.com/Bekaboo/nvim) is a collection of Neovim configuration files inspired
by [Emacs / N Λ N O](https://github.com/rougier/nano-emacs).

The goal of macro-neovim is to provide a clean and elegant user interface
while remaining practical for daily tasks, striking a balance between a
streamlined design and effective functionality. See [showcases](#showcases) to
get a glimpse of the basic usage and what this configuration looks like.

This is a highly personalized and opinionated Neovim configuration, not a
distribution. While it's not meant for direct use, you're welcome to fork,
experiment, and adapt it to your liking. Feel free to use it as a starting
point for your configuration or borrow elements you find useful. Issues and PRs
are welcome.

Currently only supports Linux (X11/Wayland/TTY).

<center>
    <img src="https://github.com/Bekaboo/nvim/assets/76579810/299137e7-9438-489b-b98b-7211a62678ae" width=46%>  
    <img src="https://github.com/Bekaboo/nvim/assets/76579810/9e546e33-7678-47e2-8a80-368d7c59534a" width=46%>
</center>

## Table of Contents

<!--toc:start-->
- [Features](#features)
- [Requirements and Dependencies](#requirements-and-dependencies)
  - [Basic](#basic)
  - [Tree-sitter](#tree-sitter)
  - [LSP](#lsp)
  - [DAP](#dap)
  - [Formatter](#formatter)
- [Installation](#installation)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)
- [Config Structure](#config-structure)
- [Tweaking this Configuration](#tweaking-this-configuration)
  - [Managing Plugins with Modules](#managing-plugins-with-modules)
  - [Installing Packages to an Existing Module](#installing-packages-to-an-existing-module)
  - [Installing Packages to a New Module](#installing-packages-to-a-new-module)
  - [General Settings and Options](#general-settings-and-options)
  - [Environment Variables](#environment-variables)
  - [Keymaps](#keymaps)
  - [Colorschemes](#colorschemes)
  - [Auto Commands](#auto-commands)
  - [LSP Server Configurations](#lsp-server-configurations)
  - [DAP Configurations](#dap-configurations)
  - [Snippets](#snippets)
  - [Enabling VSCode Integration](#enabling-vscode-integration)
- [Appendix](#appendix)
  - [Showcases](#showcases)
  - [Default Modules and Plugins of Choice](#default-modules-and-plugins-of-choice)
    - [Third Party Plugins](#third-party-plugins)
    - [Builtin Plugins](#builtin-plugins)
  - [Startuptime](#startuptime)
<!--toc:end-->

## Features

- Modular design
    - Install and manage packages in groups
    - Make it easy to use different set of configuration for different use
      cases
- Clean and uncluttered UI, including customized versions of:
    - [winbar](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/winbar)
    - [statusline](https://github.com/Bekaboo/nvim/blob/master/lua/plugin/statusline.lua)
    - [statuscolumn](https://github.com/Bekaboo/nvim/blob/master/lua/plugin/statuscolumn.lua)
    - [colorschemes](https://github.com/Bekaboo/nvim/tree/master/colors)
    - [intro message](https://github.com/Bekaboo/nvim/blob/master/plugin/intro.lua)
- [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim) integration, makes you feel at home in VSCode when you
  occasionally need it
- Massive [TeX math snippets](https://github.com/Bekaboo/nvim/blob/master/lua/snippets/shared/math.lua)
- Jupyter Notebook integration: edit notebooks like markdown files, run code in
  cells with simple commands and shortcuts
- [Fine-tuned plugins](https://github.com/Bekaboo/nvim/tree/master/lua/configs) with [custom patches](https://github.com/Bekaboo/nvim/tree/master/patches)
- Optimization for large files, open any file larger than 100 MB and edit like
  butter
- Fast startup around [~25 ms](#startuptime)

## Requirements and Dependencies

### Basic

- [Neovim](https://github.com/neovim/neovim) 0.10, for exact version see [nvim-version.txt](https://github.com/Bekaboo/nvim/blob/master/nvim-version.txt)
- [Git](https://git-scm.com/)
- [GCC](https://gcc.gnu.org/) or [Clang](https://clang.llvm.org/) for building treesitter parsers and some libs
- [Fd](https://github.com/sharkdp/fd), [Ripgrep](https://github.com/BurntSushi/ripgrep), and [Fzf](https://github.com/junegunn/fzf) for fuzzy search
- [Pandoc](https://pandoc.org/), [custom scripts](https://github.com/Bekaboo/dot/tree/master/.scripts) and [TexLive](https://www.tug.org/texlive/) (for ArchLinux users, it is `texlive-core` and `texlive-extra`) for markdown → PDF conversion (`:MarkdownToPDF`)
- [Node.js](https://nodejs.org/en) for installing dependencies for [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
- [Pynvim](https://github.com/neovim/pynvim), [Jupyter Client](https://github.com/jupyter/jupyter_client), and [IPython Kernel](https://github.com/ipython/ipykernel) for Python support
- [Jupytext](https://github.com/mwouts/jupytext) for editing Jupyter notebooks
- A decent terminal emulator
- A nerd font, e.g. [JetbrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono).
  This is optional as nerd icons are disabled by default, to enable it, set the
  environment variable `$NVIM_NF`, see [environment variables](#environment-variables)

### Tree-sitter

Tree-sitter installation and configuration are handled by [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).

Requires a C compiler, e.g. [GCC](https://gcc.gnu.org/) or [Clang](https://clang.llvm.org/), for building parsers.

To add or remove support for a language, install or uninstall the corresponding
parser using `:TSInstall` or `:TSUninstall`.

To make the change permanent, add or remove corresponding parsers in the
`ensure_installed` field in the call to nvim-treesitter's `setup()` function,
see [lua/configs/nvim-treesitter.lua](https://github.com/Bekaboo/nvim/blob/master/lua/configs/nvim-treesitter.lua).

### LSP

For LSP support, install the following language servers manually using your
favorite package manager:

- Bash: [BashLS](https://github.com/bash-lsp/bash-language-server)

    Example for ArchLinux users:

    ```sh
    sudo pacman -S bash-language-server
    ```

- C/C++: [Clang](https://clang.llvm.org/)
- Lua: [LuaLS](https://github.com/LuaLS/lua-language-server)
- Python: one of
    - [Jedi Language Server](https://github.com/pappasam/jedi-language-server)
    - [Python LSP Server](https://github.com/python-lsp/python-lsp-server)
    - [Pyright](https://github.com/microsoft/pyright)
- Rust: [Rust Analyzer](https://rust-analyzer.github.io/)
- LaTeX: [TexLab](https://github.com/latex-lsp/texlab)
- VimL: [VimLS](https://github.com/iamcco/vim-language-server)
- Markdown: [Marksman](https://github.com/artempyanykh/marksman)
- Go: [Gopls](https://github.com/golang/tools/tree/master/gopls)
- Typescript: [Typescript Language Server](https://github.com/typescript-language-server/typescript-language-server) and [Biome](https://biomejs.dev/) 
- General-purpose language server: [EFM Language Server](https://github.com/mattn/efm-langserver)
    - Already configured for
        - [Black](https://github.com/psf/black) (formatter)
        - [Shfmt](https://github.com/mvdan/sh) (formatter)
        - [Fish-indent](https://fishshell.com/docs/current/cmds/fish_indent.html) (formatter)
        - [StyLua](https://github.com/JohnnyMorganz/StyLua) (formatter)
        - [Gofmt](https://pkg.go.dev/cmd/gofmt) (formatter)
        - [Golangcli-lint](https://github.com/golangci/golangci-lint) (linter)
        - [Prettier](https://prettier.io/) (formatter)
        - [Eslint](https://eslint.org/) (linter)
        - ...

To add support for other languages, install corresponding language servers
manually then add `lsp.lua` files under [after/ftplugin](https://github.com/Bekaboo/nvim/tree/master/after/ftplugin) to automatically launch
them for different filetypes.

Some examples of `lsp.lua` files:

- [after/ftplugin/lua/lsp.lua](https://github.com/Bekaboo/nvim/blob/master/after/ftplugin/lua/lsp.lua)
- [after/ftplugin/python/lsp.lua](https://github.com/Bekaboo/nvim/blob/master/after/ftplugin/python/lsp.lua)
- [after/ftplugin/rust/lsp.lua](https://github.com/Bekaboo/nvim/blob/master/after/ftplugin/rust/lsp.lua)
- [after/ftplugin/sh/lsp.lua](https://github.com/Bekaboo/nvim/blob/master/after/ftplugin/sh/lsp.lua)
- [after/ftplugin/go/lsp.lua](https://github.com/Bekaboo/nvim/blob/master/after/ftplugin/go/lsp.lua)
- [after/ftplugin/typescript/lsp.lua](https://github.com/Bekaboo/nvim/blob/master/after/ftplugin/typescript/lsp.lua)

### DAP

Install the following debug adapters manually:

- Bash:

    Go to [vscode-bash-debug release page](https://github.com/rogalmic/vscode-bash-debug/releases),
    download the latest release (`bash-debug-x.x.x.vsix`), extract
    (change the extension from `.vsix` to `.zip` then unzip it) the contents
    to a new directory `vscode-bash-debug/` and put it under stdpath `data`
    (see `:h stdpath`).

    Make sure `node` is executable.

- C/C++: install [CodeLLDB](https://github.com/vadimcn/codelldb).

    Example for ArchLinux users:

    ```sh
    yay -S codelldb     # Install from AUR
    ```

- Python: install [DebugPy](https://github.com/microsoft/debugpy)

    Example for ArchLinux users:

    ```sh
    sudo pacman -S python-debugpy
    ```

    or

    ```sh
    pip install --local debugpy # Install to user's home directory
    ```

- Go: install [Delve](https://github.com/go-delve/delve)

For more information on DAP installation, see [Debug Adapter Installation](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation).

### Formatter

- Bash: install [Shfmt](https://github.com/mvdan/sh)\*
- C/C++: install [Clang](https://clang.llvm.org/) to use `clang-format`
- Lua: install [StyLua](https://github.com/JohnnyMorganz/StyLua)\*
- Rust: install [Rust](https://www.rust-lang.org/tools/install) to use `rustfmt`
- Python: install [Black](https://github.com/psf/black)\*
- LaTeX: install [texlive-core](http://tug.org/texlive/) to use `latexindent`

<sub>\*Need [EFM Language Server](https://github.com/mattn/efm-langserver) to work with `vim.lsp.buf.format()`</sub>

## Installation

1. Make sure you have required dependencies installed.
2. Clone this repo to your config directory

    ```sh
    git clone https://github.com/Bekaboo/nvim ~/.config/nvim-macro
    ```

4. Open neovim using 

    ```sh
    NVIM_APPNAME=nvim-macro nvim
    ```

    On first installation, neovim will prompt you to decide whether to install
    third-party plugins, press `y` to install, `n` to skip, `never` to skip and
    disable the prompt in the future (aka "do not ask again").

    The suggestion is to use `n` to skip installing plugins on first launch,
    and see if everything works OK under a bare minimum setup. Depending on
    your needs, you can choose whether to install third-party plugins later
    using `y`/`yes` or `never` on the second launch.

    **Some notes about third-party plugins**

    Installing third-party plugins is known to cause issues in some cases,
    including:

    1. Partially cloned plugins and missing dependencies due to slow network
       connection
    2. Building failure especially for plugins like [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
       and [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) due to missing building dependencies or slow
       installation process
    3. Treesitter plugins can easily cause issues if you are on a different
       nvim version, check [nvim-version.txt](https://github.com/Bekaboo/nvim/blob/master/nvim-version.txt) for the version of nvim targeted by
       this config

    To avoid these issues,

    1. Ensure you have a fast network before installing third-party plugins
    2. If the building process failed, go to corresponding project directory
       under `g:package_path` and manually run the build command from there.
       The build commands are declared in module specification files under
       [lua/modules](https://github.com/Bekaboo/nvim/tree/master/lua/modules)
    3. Ensure you are on the same version of nvim as specified in
       [nvim-version.txt](https://github.com/Bekaboo/nvim/blob/master/nvim-version.txt) if you encounter any issue related to treesitter

5. After entering neovim, Run `:checkhealth` to check potential dependency
   issues.
6. Enjoy!

## Troubleshooting

If you encounter any issue, please try the following steps:

1. Run `:Lazy restore` once to ensure that all packages are properly
   installed and **patched**

2. Run `:checkhealth` to check potential dependency issues

3. Check `:version` to make sure you are on the same (of above) version of
   neovim as specified in [nvim-version.txt](https://github.com/Bekaboo/nvim/blob/master/nvim-version.txt)

4. Try removing the following paths then restart Neovim:

    - `:echo stdpath('cache')`
    - `:echo stdpath('state')`
    - `:echo stdpath('data')`

5. If still not working, please open an issue and I will be happy to help

## Uninstallation

You can uninstall this config completely by simply removing the following
paths:

- `:echo stdpath('config')`
- `:echo stdpath('cache')`
- `:echo stdpath('state')`
- `:echo stdpath('data')`

## Config Structure

```
.
├── colors                      # colorschemes
├── plugin                      # custom plugins
├── ftplugin                    # custom filetype plugins
├── init.lua                    # entry of config
├── lua
│   ├── core                    # files under this folder is required by 'init.lua'
│   │   ├── autocmds.lua
│   │   ├── general.lua         # options and general settings
│   │   ├── keymaps.lua
│   │   └── modules.lua         # bootstraps plugin manager and specifies which modules to include
│   ├── modules                 # all plugin specifications and configs go here
│   │   ├── lib.lua             # plugin specifications in module 'lib'
│   │   ├── completion.lua      # plugin specifications in module 'completion'
│   │   ├── debug.lua           # plugin specifications in modules 'debug'
│   │   ├── langs.lua           # plugin specifications in module 'langs'
│   │   ├── markup.lua          # ...
│   │   ├── llm.lua
│   │   ├── tools.lua
│   │   ├── treesitter.lua
│   │   └── colorschemes.lua
│   ├── configs                 # configs for each plugin
│   ├── snippets                # snippets
│   ├── plugin                  # the actual implementation of custom plugins
│   └── utils
└── syntax                      # syntax files
```

## Tweaking this Configuration

### Managing Plugins with Modules

In order to enable or disable a module, one need to change the table in
[lua/core/modules.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/modules.lua) passed to `enable_modules()`, for example

```lua
enable_modules({
  'lib',
  'treesitter',
  'edit',
  -- ...
})
```

### Installing Packages to an Existing Module

To install plugin `foo` under module `bar`, just insert the corresponding
specification to the big table `lua/modules/bar.lua` returns, for instance,

`lua/modules/bar.lua`:

```lua
return {
  -- ...
  {
    'foo/foo',
    dependencies = 'foo_dep',
  },
}
```

### Installing Packages to a New Module

To install plugin `foo` under module `bar`, one should first
create module `bar` under [lua/modules](https://github.com/Bekaboo/nvim/tree/master/lua/modules):

```
.
└── lua
    └── modules
        └── bar.lua
```

a module should return a big table containing all specifications of plugins
under that module, for instance:

```lua
return {
  {
    'goolord/alpha-nvim',
    cond = function()
      return vim.fn.argc() == 0 and
          vim.o.lines >= 36 and vim.o.columns >= 80
    end,
    dependencies = 'nvim-web-devicons',
  },

  {
    'romgrk/barbar.nvim',
    dependencies = 'nvim-web-devicons',
    config = function() require('bufferline').setup() end,
  },
}
```

After creating the new module `bar`, enable it in [lua/core/modules.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/modules.lua):

```lua
enable_modules({
  -- ...
  'bar',
  -- ...
})
```

### General Settings and Options

See [lua/core/general.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/general.lua).

### Environment Variables

- `$NVIM_NO3RD`: disable third-party plugins if set
- `$NVIM_NF`: enable nerd font icons if set

### Keymaps

See [lua/core/keymaps.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/keymaps.lua), or see [module config files](https://github.com/Bekaboo/nvim/tree/master/lua/configs) for
corresponding plugin keymaps.

### Colorschemes

`cockatoo`, `nano`, `macro`, and `sonokai` are three builtin custom
colorschemes, with separate palettes for dark and light background.

Neovim is configured to restore the previous background and colorscheme
settings on startup, so there is no need to set them up in the config file
explicitly.

To disable the auto-restore feature, remove the plugin [plugin/colorscheme.lua](https://github.com/Bekaboo/nvim/tree/master/plugin/colorscheme.lua).

To tweak this colorscheme, edit corresponding colorscheme files under [colors](https://github.com/Bekaboo/nvim/tree/master/colors).

### Auto Commands

See [lua/core/autocmds.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/autocmds.lua).

### LSP Server Configurations

See [lua/utils/lsp.lua](https://github.com/Bekaboo/nvim/tree/master/lua/utils/lsp.lua) and `lsp.lua` files under [after/ftplugin](https://github.com/Bekaboo/nvim/tree/master/after/ftplugin).

### DAP Configurations

See [lua/configs/dap-configs](https://github.com/Bekaboo/nvim/tree/master/lua/configs/dap-configs), [lua/configs/nvim-dap.lua](https://github.com/Bekaboo/nvim/tree/master/lua/configs/nvim-dap.lua), and [lua/configs/nvim-dap-ui.lua](https://github.com/Bekaboo/nvim/tree/master/lua/configs/nvim-dap-ui.lua).

### Snippets

This configuration use [LuaSnip](https://github.com/L3MON4D3/LuaSnip) as the snippet engine,
custom snippets for different filetypes
are defined under [lua/snippets](https://github.com/Bekaboo/nvim/tree/master/lua/snippets).

### Enabling VSCode Integration

VSCode integration takes advantages of the modular design, allowing to use
a different set of modules when Neovim is launched by VSCode, relevant code is
in [autoload/plugin/vscode.vim](https://github.com/Bekaboo/nvim/blob/master/autoload/plugin/vscode.vim) and [lua/core/modules.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/modules.lua).

To make VSCode integration work, please install [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim) in VSCode
and configure it correctly.

After setting up VSCode-Neovim, re-enter VSCode, open a random file
and it should work out of the box.

## Appendix

### Showcases

- File manager using [oil.nvim](https://github.com/stevearc/oil.nvim)

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/26bb146f-7637-4f68-acd7-baecc08f1eaf" width=75%>

- DAP support powered by [nvim-dap](https://github.com/mfussenegger/nvim-dap) and [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/f6c7e6ce-283b-43d7-8bc3-e8b24513a03b" width=75%>

- Jupyter Notebook integration using [jupytext](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/jupytext.lua) and [molten-nvim](https://github.com/benlubas/molten-nvim)

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/ce212348-8b89-4a03-a222-ab74f0338a7d" width=75%>

- Winbar with IDE-like drop-down menus using [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim)

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/247401a9-6127-4d73-bb21-ceb847d8f7b9" width=75%>

- LSP hover & completion thanks to Neovim builtin LSP client and [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/13589137-b5c7-4104-810c-f8cdc56f9d1b" width=75%>

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/60c5b599-4191-494d-ad83-1ca7a84eab17" width=75%>

- Git integration: [fugitive](https://github.com/tpope/vim-fugitive) and [gitsigns.nvim](https://github.com/tpope/vim-fugitive)

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/a5e0a41d-4e85-4bfc-a39d-cc7b76abedcf" width=75%>

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/73da4ee1-8f6c-440a-9eb9-0bcf3bc8e3ea" width=75%>

### Default Modules and Plugins of Choice

#### Third Party Plugins

Total # of plugins: 50 (package manager included).

- **Lib**
    - [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)
- **Completion**
    - [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
    - [cmp-calc](https://github.com/hrsh7th/cmp-calc)
    - [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)
    - [cmp-path](https://github.com/hrsh7th/cmp-path)
    - [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
    - [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
    - [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
    - [cmp-nvim-lsp-signature-help](https://github.com/hrsh7th/cmp-nvim-lsp-signature-help)
    - [cmp-dap](https://github.com/rcarriga/cmp-dap)
    - [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- **LLM**
    - [codeium.vim](https://github.com/Exafunction/codeium.vim)
    - [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim)
- **Markup**
    - [vimtex](https://github.com/lervag/vimtex)
    - [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
    - [vim-table-mode](https://github.com/dhruvasagar/vim-table-mode)
    - [otter.nvim](https://github.com/jmbuhr/otter.nvim)
    - [molten-nvim](https://github.com/benlubas/molten-nvim)
    - [headlines.nvim](https://github.com/lukas-reineke/headlines.nvim)
    - [img-clip.nvim](https://github.com/HakonHarnes/img-clip.nvim)
- **Edit**
    - [nvim-surround](https://github.com/kylechui/nvim-surround)
    - [vim-sleuth](https://github.com/tpope/vim-sleuth)
    - [ultimate-autopairs.nvim](https://github.com/altermo/ultimate-autopair.nvim)
    - [vim-easy-align](https://github.com/junegunn/vim-easy-align)
- **Tools**
    - [fzf-lua](https://github.com/ibhagwan/fzf-lua)
    - [flatten.nvim](https://github.com/willothy/flatten.nvim)
    - [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
        - [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) (dependency)
    - [git-conflict](https://github.com/akinsho/git-conflict.nvim)
    - [nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)
    - [vim-fugitive](https://github.com/tpope/vim-fugitive)
        - [vim-rhubarb](https://github.com/tpope/vim-rhubarb) (dependency)
        - [fugitive-gitlab.vim](https://github.com/shumphrey/fugitive-gitlab.vim) (dependency)
    - [oil.nvim](https://github.com/stevearc/oil.nvim)
- **LSP**
    - [clangd_extensions.nvim](https://github.com/p00f/clangd_extensions.nvim)
- **Treesitter**
    - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
    - [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
    - [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
    - [nvim-treesitter-endwise](https://github.com/RRethy/nvim-treesitter-endwise)
    - [treesj](https://github.com/Wansmer/treesj)
    - [cellular-automaton.nvim](https://github.com/Eandrju/cellular-automaton.nvim)
- **Debug**
    - [nvim-dap](https://github.com/mfussenegger/nvim-dap)
    - [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
        - [nvim-nio](https://github.com/nvim-neotest/nvim-nio) (dependency)
    - [one-small-step-for-vimkind](https://github.com/jbyuki/one-small-step-for-vimkind)
- **Colorschemes**
    - [everforest](https://github.com/sainnhe/everforest)
    - [gruvbox-material](https://github.com/sainnhe/gruvbox-material)

#### Builtin Plugins

- [colorcolumn](https://github.com/Bekaboo/nvim/tree/master/plugin/colorcolumn.lua)
    - Shows color column dynamically based on current line width
    - Released as [deadcolumn.nvim](https://github.com/Bekaboo/deadcolumn.nvim)
- [colorscheme](https://github.com/Bekaboo/nvim/tree/master/plugin/colorscheme.lua)
    - Remembers and restores previous background and colorscheme settings
    - Syncs background and colorscheme settings among multiple Neovim instances
      if scripts [setbg](https://github.com/Bekaboo/dot/blob/master/.scripts/setbg) and [setcolor](https://github.com/Bekaboo/dot/blob/master/.scripts/setcolor) are in `$PATH`
- [expandtab](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/expandtab.lua)
    - Always use spaces for alignment, even if `'expandtab'` is not set, see
      `:h 'tabstop'` point 5
- [fcitx5](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/fcitx5.lua)
    - Switches and restores fcitx5 state in each buffer asynchronously
- [jupytext](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/jupytext.lua)
    - Edits jupyter notebook like markdown files
    - Writes into jupyter notebook asynchronously, which gives a smoother
      experience than [jupytext.vim](https://github.com/goerz/jupytext)
- [intro](https://github.com/Bekaboo/nvim/tree/master/plugin/intro.lua)
    - Shows a custom intro message on startup
- [lsp](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/lsp.lua)
    - Sets up LSP and diagnostic options and commands on `LspAttach` or
      `DiagnosticChanged`
- [readline](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/readline.lua)
    - Readline-like keybindings in insert and command mode
- [statuscolumn](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/statuscolumn.lua)
    - Custom statuscolumn, with git signs on the right of line numbers
- [statusline](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/statusline.lua)
    - Custom statusline inspired by [nano-emacs](https://github.com/rougier/nano-emacs)
- [tabline](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/tabline.lua)
    - Simple tabline that shows the current working directory of each tab
    - Use `:[count]TabRename [name]` to rename tabs
- [tabout](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/tabout.lua)
    - Tab out and in with `<Tab>` and `<S-Tab>`
- [term](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/term.lua)
    - Some nice setup for terminal buffers
- [tmux](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/tmux.lua)
    - Integration with tmux, provides unified keymaps for navigation, resizing,
      and many other window operations
- [vscode](https://github.com/Bekaboo/nvim/tree/master/autoload/plugin/vscode.vim)
    - Integration with [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim)
- [winbar](https://github.com/Bekaboo/nvim/blob/master/lua/plugin/winbar.lua)
    - A winbar with drop-down menus and multiple backends
    - Released as [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim)
- [markdown-capitalized-title](https://github.com/Bekaboo/nvim/blob/master/after/ftplugin/markdown/capitalized-title.lua)
    - Automatically capitalize the first letter of each word in markdown titles
    - Use `:MarkdownSetCapTitle enable/disable` to enable or disable this
      feature

### Startuptime

- Neovim Version:

    ```
    NVIM v0.10.0-dev-2363+gb76a01055f
    Build type: Release
    LuaJIT 2.1.1702233742
    ```

- Config Commit: `5970178e`

- System: Arch Linux 6.7.4-arch1-1

- Machine: Dell XPS 13-7390

- Startup time with `--clean`:

    ```sh
    hyperfine 'nvim --clean +q'
    ```

    ```
    Benchmark 1: nvim --clean +q
      Time (mean ± σ):       9.4 ms ±   1.9 ms    [User: 6.3 ms, System: 3.2 ms]
      Range (min … max):     6.5 ms …  15.1 ms    185 runs
    ```

- Startup time with this config:

    ```sh
    hyperfine 'nvim +q'
    ```

    ```
    Benchmark 1: nvim +q
      Time (mean ± σ):      18.1 ms ±   1.3 ms    [User: 13.6 ms, System: 4.5 ms]
      Range (min … max):    15.5 ms …  22.0 ms    127 runs
    ```

    <details>
      <summary>startuptime log</summary>

    ```
    --- Startup times for process: Primary/TUI ---

    times in msec
     clock   self+sourced   self:  sourced script
     clock   elapsed:              other lines

    000.002  000.002: --- NVIM STARTING ---
    000.168  000.166: event init
    000.252  000.083: early init
    000.305  000.053: locale set
    000.352  000.047: init first window
    000.615  000.263: inits 1
    000.624  000.009: window checked
    000.626  000.002: parsing arguments
    001.130  000.063  000.063: require('vim.shared')
    001.229  000.057  000.057: require('vim.inspect')
    001.281  000.037  000.037: require('vim._options')
    001.282  000.148  000.053: require('vim._editor')
    001.284  000.258  000.048: require('vim._init_packages')
    001.290  000.405: init lua interpreter
    001.872  000.583: expanding arguments
    001.908  000.036: inits 2
    002.302  000.394: init highlight
    002.306  000.003: --- NVIM STARTED ---

    --- Startup times for process: Embedded ---

    times in msec
     clock   self+sourced   self:  sourced script
     clock   elapsed:              other lines

    000.002  000.002: --- NVIM STARTING ---
    000.165  000.163: event init
    000.242  000.077: early init
    000.295  000.053: locale set
    000.336  000.041: init first window
    000.568  000.232: inits 1
    000.582  000.015: window checked
    000.589  000.007: parsing arguments
    001.084  000.038  000.038: require('vim.shared')
    001.192  000.047  000.047: require('vim.inspect')
    001.239  000.036  000.036: require('vim._options')
    001.241  000.154  000.070: require('vim._editor')
    001.242  000.261  000.069: require('vim._init_packages')
    001.244  000.394: init lua interpreter
    001.299  000.054: expanding arguments
    001.316  000.017: inits 2
    001.554  000.238: init highlight
    001.555  000.001: waiting for UI
    001.649  000.094: done waiting for UI
    001.652  000.003: clear screen
    001.688  000.006  000.006: require('vim.keymap')
    001.947  000.293  000.287: require('vim._defaults')
    001.950  000.005: init default mappings & autocommands
    002.376  000.051  000.051: sourcing /usr/share/nvim/runtime/ftplugin.vim
    002.433  000.025  000.025: sourcing /usr/share/nvim/runtime/indent.vim
    002.499  000.010  000.010: sourcing /usr/share/nvim/archlinux.vim
    002.502  000.030  000.020: sourcing /etc/xdg/nvim/sysinit.vim
    003.043  000.041  000.041: require('vim.fs')
    003.205  000.133  000.133: require('vim.uri')
    003.222  000.243  000.069: require('vim.loader')
    003.756  001.216  000.973: require('core.general')
    005.768  002.008  002.008: require('core.keymaps')
    006.053  000.282  000.282: require('core.autocmds')
    006.262  000.089  000.089: require('utils')
    006.343  000.078  000.078: require('utils.static')
    006.695  000.221  000.221: require('utils.static.icons._icons')
    006.699  000.353  000.133: require('utils.static.icons')
    007.039  000.076  000.076: require('modules.lib')
    007.189  000.065  000.065: require('modules.edit')
    007.287  000.060  000.060: require('modules.debug')
    007.355  000.064  000.064: require('modules.tools')
    007.408  000.047  000.047: require('modules.markup')
    007.455  000.042  000.042: require('modules.completion')
    007.519  000.060  000.060: require('modules.treesitter')
    007.559  000.036  000.036: require('modules.colorschemes')
    008.221  000.658  000.658: require('lazy')
    008.250  000.011  000.011: require('ffi')
    008.336  000.081  000.081: require('lazy.stats')
    008.450  000.094  000.094: require('lazy.core.util')
    008.536  000.083  000.083: require('lazy.core.config')
    008.680  000.062  000.062: require('lazy.core.handler')
    008.798  000.115  000.115: require('lazy.core.plugin')
    008.812  000.274  000.098: require('lazy.core.loader')
    010.241  000.085  000.085: require('lazy.core.handler.cmd')
    010.349  000.103  000.103: require('lazy.core.handler.event')
    010.532  000.178  000.178: require('lazy.core.handler.keys')
    010.698  000.160  000.160: require('lazy.core.handler.ft')
    011.196  000.024  000.024: sourcing /home/zeng/.local/share/nvim/packages/vimtex/ftdetect/cls.vim
    011.247  000.017  000.017: sourcing /home/zeng/.local/share/nvim/packages/vimtex/ftdetect/tex.vim
    011.288  000.021  000.021: sourcing /home/zeng/.local/share/nvim/packages/vimtex/ftdetect/tikz.vim
    012.812  000.190  000.190: sourcing /usr/share/nvim/runtime/filetype.lua
    012.886  000.006  000.006: require('vim.F')
    013.509  000.127  000.127: sourcing /home/zeng/.config/nvim/plugin/_load.lua
    013.677  000.064  000.064: require('utils.hl')
    013.762  000.226  000.162: sourcing /home/zeng/.config/nvim/plugin/colorcolumn.lua
    013.915  000.041  000.041: require('utils.json')
    013.991  000.073  000.073: require('utils.fs')
    015.510  000.962  000.962: sourcing /home/zeng/.config/nvim/colors/macro.lua
    015.701  001.914  000.838: sourcing /home/zeng/.config/nvim/plugin/colorscheme.lua
    016.132  000.098  000.098: require('vim.highlight')
    016.280  000.550  000.452: sourcing /home/zeng/.config/nvim/plugin/intro.lua
    016.466  000.063  000.063: sourcing /usr/share/nvim/runtime/plugin/editorconfig.lua
    016.531  000.018  000.018: sourcing /usr/share/nvim/runtime/plugin/gzip.vim
    016.626  000.069  000.069: sourcing /usr/share/nvim/runtime/plugin/man.lua
    016.672  000.013  000.013: sourcing /usr/share/nvim/runtime/plugin/matchit.vim
    016.831  000.136  000.136: sourcing /usr/share/nvim/runtime/plugin/matchparen.vim
    016.873  000.012  000.012: sourcing /usr/share/nvim/runtime/plugin/netrwPlugin.vim
    016.954  000.060  000.060: sourcing /usr/share/nvim/runtime/plugin/nvim.lua
    017.030  000.054  000.054: sourcing /usr/share/nvim/runtime/plugin/osc52.lua
    017.061  000.008  000.008: sourcing /usr/share/nvim/runtime/plugin/rplugin.vim
    017.135  000.052  000.052: sourcing /usr/share/nvim/runtime/plugin/shada.vim
    017.190  000.016  000.016: sourcing /usr/share/nvim/runtime/plugin/spellfile.vim
    017.226  000.010  000.010: sourcing /usr/share/nvim/runtime/plugin/tarPlugin.vim
    017.256  000.008  000.008: sourcing /usr/share/nvim/runtime/plugin/tohtml.vim
    017.284  000.006  000.006: sourcing /usr/share/nvim/runtime/plugin/tutor.vim
    017.326  000.011  000.011: sourcing /usr/share/nvim/runtime/plugin/zipPlugin.vim
    017.410  011.355  005.044: require('core.packages')
    017.413  014.890  000.028: sourcing /home/zeng/.config/nvim/init.lua
    017.419  000.473: sourcing vimrc file(s)
    017.522  000.051  000.051: sourcing /usr/share/nvim/runtime/filetype.lua
    017.665  000.056  000.056: sourcing /usr/share/nvim/runtime/syntax/synload.vim
    017.767  000.209  000.153: sourcing /usr/share/nvim/runtime/syntax/syntax.vim
    017.779  000.101: inits 3
    017.959  000.129  000.129: require('plugin.statuscolumn')
    018.237  000.329: opening buffers
    018.258  000.020: BufEnter autocommands
    018.259  000.002: editing files in windows
    018.280  000.021: VimEnter autocommands
    018.340  000.060: UIEnter autocommands
    018.567  000.179  000.179: sourcing /usr/share/nvim/runtime/autoload/provider/clipboard.vim
    018.573  000.053: before starting main loop
    018.911  000.074  000.074: require('utils.stl')
    019.334  000.379  000.379: require('plugin.statusline')
    019.542  000.130  000.130: require('utils.git')
    019.754  000.197  000.197: require('vim._system')
    021.197  001.843: first screen update
    021.201  000.004: --- NVIM STARTED ---
    ```

    </details>
