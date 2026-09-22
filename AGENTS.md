# AGENTS.md

Instructions, conventions, and architectural reference for AI coding agents working on this Neovim configuration repository.

---

## 1. Repository Overview

This repository is a fast, modern, standalone **Neovim** (v0.12+) user configuration maintained by **Pim Stohr** (`pstohr`). It uses Neovim's built-in native package manager (**`vim.pack`**) and provides an optimized development environment for Lua, Rust, and Python workflows with integrated AI completion (GitHub Copilot), Neogit, DAP debugging, and custom UI styling.

### Key Technologies
- **Core Editor**: Neovim (v0.12+ / LuaJIT runtime)
- **Plugin Manager**: Native Neovim package manager (`vim.pack`)
- **Lockfile**: `nvim-pack-lock.json` (managed via `vim.pack`)
- **Theme**: Catppuccin Mocha (transparent background) with Lualine status bar and Bufferline tabs
- **Completion & AI**: `nvim-cmp`, `LuaSnip`, and `copilot.lua`
- **LSP / DAP / Linters**: `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, `nvim-dap`, `mason-nvim-dap.nvim`, `ruff`, `ty`, `pylsp`, `debugpy`, `stylua`

---

## 2. Directory Structure

```text
~/.config/nvim/
├── init.lua                 # Entrypoint: sets packpath, loads config, initializes vim.pack and plugins
├── nvim-pack-lock.json      # Native lockfile tracking plugin revisions and sources
├── .stylua.toml             # StyLua formatting rules (120 cols, 2 spaces, Unix endings, AutoPreferDouble)
├── selene.toml              # Selene Lua linter configuration (neovim std)
├── .neoconf.json            # Project-local settings for lua_ls
├── neovim.yml               # Neovim YAML config (Lua 5.1 base, globals definition)
├── README.md                # Documentation and setup instructions
├── AGENTS.md                # This file: instructions and architecture reference for AI agents
└── lua/
    ├── pack.lua             # Central vim.pack specifications (vim.pack.add)
    ├── config/
    │   ├── options.lua      # Core Vim options, sensible editor defaults, Windows Git Bash fix, rounded preview borders
    │   ├── keymaps.lua      # Global keymaps (leader = <Space>, buffer navigation, window navigation, pack shortcuts)
    │   └── autocmds.lua     # General autocmds (highlight yank, cursor restore) and PackChanged build hooks
    └── plugins/             # Modular plugin setup files (pure Lua modules)
        ├── completion.lua   # nvim-cmp, luasnip, copilot.lua coordination, tab overload
        ├── dap.lua          # nvim-dap setup: Python debugpy adapters, pytest configurations, dap-ui
        ├── dashboard.lua    # Alpha dashboard: custom 3D wireframe ASCII art, dynamic greeting for Pim, buttons, quotes
        ├── git.lua          # Neogit, Diffview, and Gitsigns setup
        ├── lsp.lua          # Mason, nvim-lspconfig (ruff, ty, pylsp, lua_ls), format-on-save
        ├── neo-tree.lua     # Neo-tree file explorer setup with custom icons and git status
        ├── telescope.lua    # Telescope fuzzy finder with fzf-native extension
        ├── theme.lua        # Catppuccin-mocha setup, transparency, and plugin integrations
        ├── toggleterm.lua   # Terminal mappings: jk/<esc> to exit terminal mode, <C-h/j/k/l> navigation
        ├── treesitter.lua   # Treesitter parsers, autopairs, and comments setup
        └── ui.lua           # Lualine, Bufferline, Web Devicons, Which-Key, Indent-Blankline, and Notify
```

---

## 3. Architecture & Bootstrapping Flow

The editor initialization follows a clean, linear chain:

1. **`init.lua`**:
   - Ensures `stdpath("data")/site` is prepended to `vim.opt.packpath`.
   - Requires `config.options` (Vim options, indentation, UI, Windows Git Bash overrides).
   - Requires `config.keymaps` (Sets `<Space>` leader key, window jumps, buffer maps).
   - Requires `config.autocmds` (Sets highlight yank, cursor restore, and `PackChanged` hooks).
   - Requires `pack` (Calls `vim.pack.add(...)` to declare and load plugins).
   - Requires modular plugin setups in `lua/plugins/*.lua`.

2. **`lua/pack.lua`**:
   - Declares the full set of plugins via `vim.pack.add({ ... }, { confirm = false })`.
   - Installed under `~/.local/share/nvim/site/pack/core/opt/<plugin_name>`.
   - State and revisions are tracked in `nvim-pack-lock.json`.

3. **`lua/config/autocmds.lua`**:
   - Listens to the `PackChanged` event to automatically build plugins upon install or update (e.g. running `make` for `telescope-fzf-native.nvim`).

---

## 4. Key Plugin Configurations & Patterns

### Dashboard (`lua/plugins/dashboard.lua`)
- **ASCII Art**: Custom extruded 3D logo rendered with character-level highlight groups (`DashboardHeaderRed`, `DashboardHeaderBlue`, `DashboardHeaderGreen`).
- **Dynamic Greeting**: Time-based greeting ("Good morning, Pim", "Good afternoon, Pim", "Good evening, Pim").
- **Footer**: Dynamic count of plugins loaded via native pack and rotating quotes.
- **Shortcuts**: Quick-launch buttons (`f` Find File, `o` Recent Files, `w` Find Word, `g` Git Status, `p` Pack Manager, `q` Quit).

### Theme & UI (`lua/plugins/theme.lua`, `lua/plugins/ui.lua`)
- **Catppuccin Mocha**: Loaded with `transparent_background = true` to inherit terminal background/blur.
- **Lualine**: Bottom statusline configured with `catppuccin-mocha` and custom separators.
- **Bufferline**: Top buffer tabs replacing legacy heirline tabline.

### Completion & Copilot Synergy (`lua/plugins/completion.lua`)
- **`<Tab>` Overload**:
  1. If Copilot suggestion is visible: calls `copilot.accept()`.
  2. Else if `cmp` completion menu is visible: calls `cmp.select_next_item()`.
  3. Else if inside an active snippet node: calls `luasnip.expand_or_jump()`.
  4. Fallback: regular Tab indent.
- **Copilot Autotrigger Guard**: Automatically hides Copilot suggestions when `nvim-cmp` menu is open or when inside an active snippet node.

### LSP & Formatting (`lua/plugins/lsp.lua`)
- **Format on Save**:
  - Python files (`*.py`) format strictly via **`ruff`** (`timeout_ms = 1000`).
  - Lua files (`*.lua`) format via **`stylua`** (ignoring `lua_ls`).
- **Python Language Servers**:
  - `ruff`: runs via `uvx ruff server` with fallback to local virtualenv (`.venv` or `venv`).
  - `ty`: fast typechecker running via `uvx ty server` with virtualenv fallback.
  - `pylsp`: completions with rope enabled, conflicting linters disabled.
  - `lua_ls`: configured with Neovim runtime and workspace settings.

### Python Debugging (`lua/plugins/dap.lua`)
- Configured for `nvim-dap` using `debugpy`.
- Auto-detects virtualenv Python (`.venv` or `venv`), cross-platform.
- Run configs: Launch file, Run pytest, Run pytest (test case).

### Terminal Navigation (`lua/plugins/toggleterm.lua`)
- Exit terminal mode without `<C-\><C-n>`: `jk` or `<esc>` in terminal mode.
- Direct window navigation: `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`.

---

## 5. Development Conventions & Guardrails for AI Agents

### 1. Adding New Plugins
- To add a plugin, add its GitHub repository URI to the `vim.pack.add` list in `lua/pack.lua`:
  ```lua
  gh("author/plugin-name"),
  ```
- Configure the plugin in a suitable module under `lua/plugins/` using standard `require("plugin").setup(...)`.
- Run `:lua vim.pack.update()` or restart Neovim to download the plugin.

### 2. Updating Plugins
- Run `:lua vim.pack.update()` or `<Leader>pu`.
- Review the diff in the confirmation buffer.
- Confirm with `:w` or cancel with `:q`.

### 3. Preserving Cross-Platform Compatibility
This configuration is used on both **Linux** and **Windows** (via Git Bash). When adding file paths or commands:
- Account for path separator with:
  ```lua
  local path_sep = package.config:sub(1, 1)
  local is_windows = path_sep == "\\"
  ```
- When resolving virtual environments:
  ```lua
  local bin_dir = is_windows and "Scripts" or "bin"
  local exe_suffix = is_windows and ".exe" or ""
  ```
- Maintain Git Bash shell settings in `lua/config/options.lua`.

### 4. Code Formatting & Linting Rules
Adhere to the standards defined in `.stylua.toml`:
- **Indent**: 2 spaces
- **Column Width**: 120 characters
- **Quotes**: Double quotes preferred (`AutoPreferDouble`)

---

## 6. Verification & Health Checks

When making changes, verify syntax and execution integrity:

1. **Headless Startup Test**:
   ```bash
   nvim --headless -c "qa"
   ```

2. **Verify Plugin Count**:
   ```bash
   nvim --headless -c "lua print('Total plugins: ' .. #vim.pack.get())" -c "qa"
   ```

3. **Check Git Status**:
   ```bash
   git status
   ```
