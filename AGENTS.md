# AGENTS.md

Instructions, conventions, and architectural reference for AI coding agents working on this Neovim configuration repository.

---

## 1. Repository Overview

This repository is a customized **AstroNvim v4+** user configuration for **Neovim** (v0.12+) maintained by **Pim Stohr** (`pstohr`). It provides a modern, fast development environment optimized for Lua, Rust, and Python workflows with integrated AI completion (GitHub Copilot), Neogit, DAP debugging, and custom UI styling.

### Key Technologies
- **Core Editor**: Neovim (LuaJIT / Lua 5.1 runtime)
- **Framework**: [AstroNvim v4+](https://github.com/AstroNvim/AstroNvim)
- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) (pinned in `lazy-lock.json`)
- **Community Packs**: [astrocommunity](https://github.com/AstroNvim/astrocommunity) (`pack.lua`, `pack.rust`)
- **Theme**: Catppuccin Mocha (transparent background) with Lualine status bar and Heirline tabline
- **Completion & AI**: `nvim-cmp`, `LuaSnip`, and `copilot.lua`
- **LSP / DAP / Linters**: AstroLSP, `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, `mason-null-ls.nvim`, `nvim-dap`, `mason-nvim-dap.nvim`, `ruff`, `ty`, `pylsp`, `debugpy`, `stylua`

---

## 2. Directory Structure

```text
~/.config/nvim/
├── init.lua                 # Entrypoint: bootstraps lazy.nvim, loads config, setup, polish, notify
├── lazy-lock.json           # Lockfile for all installed Lazy plugins (managed automatically)
├── .stylua.toml             # StyLua formatting rules (120 cols, 2 spaces, Unix endings, AutoPreferDouble)
├── selene.toml              # Selene Lua linter configuration (neovim std)
├── .neoconf.json            # Project-local settings for neodev & lua_ls
├── neovim.yml               # Neovim YAML config (Lua 5.1 base, globals definition)
├── README.md                # Upstream template documentation
├── AGENTS.md                # This file: instructions and architecture reference for AI agents
└── lua/
    ├── init.lua             # (optional/not used; root init.lua handles entry)
    ├── community.lua        # AstroCommunity plugin imports (processed BEFORE lua/plugins/)
    ├── lazy_setup.lua       # Lazy.nvim setup: AstroNvim spec, community/plugins imports, performance
    ├── polish.lua           # Last-run setup hook (custom filetypes, pure Lua overrides)
    ├── config/
    │   └── options.lua      # Core Vim options, Windows Git Bash fix, rounded floating window patch
    └── plugins/             # Modular plugin specifications (LazySpec tables)
        ├── alpha.lua        # Dashboard: custom 3D ASCII art, dynamic greeting for Pim, quick buttons, stats
        ├── astrocore.lua    # AstroCore options/mappings override (template with activation guard)
        ├── astrolsp.lua     # LSP servers (pylsp, ruff, ty), format-on-save, codelens, keymaps
        ├── astroui.lua      # UI configuration: catppuccin colorscheme, custom LSP spinner icons
        ├── cmp_ai.lua       # Optional blink.cmp tab mapping integration
        ├── copilot.lua      # GitHub Copilot integration with nvim-cmp and LuaSnip coordination
        ├── dap.lua          # nvim-dap setup: Python debugpy adapters & pytest run configs
        ├── mason-nvim-dap.lua # Mason DAP integration & python handler fallback
        ├── mason.lua        # Mason ensure_installed lists (lua_ls, stylua, python)
        ├── neogit.lua       # Neogit git porcelain configuration
        ├── none-ls.lua      # none-ls / null-ls sources override (template with activation guard)
        ├── nvim-cmp.lua     # Autocompletion engine setup: symbol icons, tab overload, Copilot sync
        ├── theme.lua        # Catppuccin-mocha setup, transparency, and plugin integrations
        ├── toggleterm.lua   # Terminal mappings: jk/<esc> to exit terminal mode, <C-h/j/k/l> navigation
        ├── treesitter.lua   # Treesitter parsers ensure_installed (lua, vim)
        ├── ui.lua           # Lualine setup and heirline statusline override
        └── user.lua         # User plugin examples template (template with activation guard)
```

---

## 3. Architecture & Bootstrapping Flow

The editor initialization follows a strictly ordered chain:

1. **`init.lua`**:
   - Checks if `lazy.nvim` is installed under `stdpath("data")/lazy/lazy.nvim`; if missing, clones the stable branch.
   - Prepends `lazypath` to `vim.opt.rtp`.
   - Requires `config.options` (Vim options & UI tweaks).
   - Requires `lazy_setup` (initializes plugin specs and downloads/loads plugins).
   - Requires `polish` (executes last for late configuration).
   - Sets `notify` background color to `#000000`.

2. **`lua/config/options.lua`**:
   - `termguicolors = true`, line numbers (`number = true`, `relativenumber = true`), `signcolumn = "yes"`.
   - **Cross-Platform Git Bash fix**: On Windows (`vim.fn.has("win32") == 1`), overrides `shell` with `C:\Program Files\Git\bin\bash.exe -i -l` and `shellcmdflag = '-s'` to fix cmd.exe `/s /c` argument conflicts.
   - **Rounded Preview Borders**: Wraps `vim.lsp.util.open_floating_preview` to default `opts.border = "rounded"`.

3. **`lua/lazy_setup.lua`**:
   - Sets leader key `<Space>` and localleader key `,` **before** Lazy initializes.
   - Loads AstroNvim base plugins (`astronvim.plugins`).
   - Imports `community` specs (`lua/community.lua`).
   - Imports user `plugins` (`lua/plugins/*.lua`).
   - Disables unnecessary Vim runtime plugins (`gzip`, `netrwPlugin`, `tarPlugin`, `tohtml`, `zipPlugin`).

4. **`lua/community.lua`**:
   - Imports community packs: `astrocommunity.pack.lua` and `astrocommunity.pack.rust`.
   - Add new community language packs or utilities here rather than manually configuring them.

5. **`lua/plugins/*.lua`**:
   - Modular `LazySpec` files. Every `.lua` file returned in this directory is merged by `lazy.nvim`.
   - Use this directory to configure or override any plugin.

6. **`lua/polish.lua`**:
   - Pure Lua execution hook that runs after all plugins and configs are loaded. Useful for custom `vim.filetype.add` definitions or late overrides.

---

## 4. Key Plugin Configurations & Patterns

### Dashboard (`lua/plugins/alpha.lua`)
- **ASCII Art**: Custom extruded 3D logo rendered with character-level highlight groups (`DashboardHeaderRed`, `DashboardHeaderBlue`, `DashboardHeaderGreen`).
- **Dynamic Greeting**: Time-based greeting ("Good morning, Pim", "Good afternoon, Pim", "Good evening, Pim").
- **Footer**: Attached via `LazyVimStarted` event displaying total plugins loaded, startup time in ms, and a rotating quote.
- **Shortcuts**: Custom quick-launch buttons (`<Leader>ff`, `<Leader>fo`, `<Leader>fw`, `<Leader>gg`, etc.).

### Theme & UI (`lua/plugins/theme.lua`, `lua/plugins/ui.lua`, `lua/plugins/astroui.lua`)
- **Catppuccin Mocha**: Loaded at priority 1000 with `transparent_background = true` to inherit terminal background/blur (e.g. Alacritty).
- **Lualine vs. Heirline**: Heirline's default statusline is disabled in `lua/plugins/ui.lua` (`opts.statusline = nil`) so `nvim-lualine/lualine.nvim` handles the bottom statusline with `catppuccin-mocha` and custom separators, while Heirline remains active for the buffer tabline at the top.
- **LSP Spinners**: Custom Braille spinners configured in `astroui.lua`.

### Completion & Copilot Synergy (`lua/plugins/nvim-cmp.lua`, `lua/plugins/copilot.lua`)
- **`<Tab>` Overload**:
  1. If Copilot suggestion is visible: calls `copilot.accept()`.
  2. Else if `cmp` completion menu is visible: calls `cmp.select_next_item()`.
  3. Else if inside an active snippet node: calls `luasnip.expand_or_jump()`.
  4. Fallback: regular Tab indent.
- **Copilot Autotrigger Guard**: Automatically hides Copilot suggestions when the `nvim-cmp` menu is open (`menu_opened` event) or when inside an active snippet (`LuasnipInsertNodeEnter`), and restores triggers once closed.
- **Copilot Hotkeys**:
  - Accept word: `<M-w>`
  - Accept line: `<M-l>`
  - Next / Prev suggestion: `<M-]>` / `<M-[>`
  - Dismiss: `/`

### LSP & Formatting (`lua/plugins/astrolsp.lua`, `lua/plugins/mason.lua`)
- **Format on Save**:
  - Globally enabled with `timeout_ms = 1000`.
  - Python files (`*.py`) format strictly via **`ruff`** (LSP client filter enforces `client.name == "ruff"`).
  - Lua files (`*.lua`) format via **`stylua`**.
  - Conflicting formatters disabled in LSP capabilities: `pylsp`, `mypy`, `null-ls`, `lua_ls`.
- **Python Language Servers**:
  - `ruff`: runs via `uvx ruff server` with fallback to local virtualenv (`.venv` or `venv`).
  - `ty`: fast typechecker/LSP running via `uvx ty server` with virtualenv fallback.
  - `pylsp`: used for completions (with rope enabled) while disabling its built-in linters (flake8, autopep8, pyflakes, pycodestyle) to avoid duplicate diagnostics with ruff.
- **Mason Installed Defaults**:
  - LSP: `lua_ls`
  - Null-ls: `stylua`
  - DAP: `python`

### Python Debugging (`lua/plugins/dap.lua`, `lua/plugins/mason-nvim-dap.lua`)
- Configured for `nvim-dap` using `debugpy` installed via Mason.
- Auto-detects virtualenv Python (`.venv` or `venv`), with cross-platform directory resolution (`Scripts/python.exe` on Windows, `bin/python` on POSIX).
- Run configs:
  - "Launch file"
  - "Run pytest" (entire file)
  - "Run pytest (test case)" (interactive test name input)

### Terminal Navigation (`lua/plugins/toggleterm.lua`)
- Exit terminal mode without `<C-\><C-n>` gymnastics: `jk` or `<esc>` in terminal mode.
- Direct window navigation from terminal mode: `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`.
- Close terminal window: `<C-w>` (mapped to `<C-d>`).

---

## 5. Development Conventions & Guardrails for AI Agents

### 1. The Template Guard Pattern
Several files in this configuration originate as AstroNvim templates and contain an early-exit guard:
```lua
if true then return end      -- in polish.lua
if true then return {} end   -- in astrocore.lua, none-ls.lua, user.lua
```
**CRITICAL**:
- If you edit one of these files to add real configuration, you **MUST remove or comment out** the `if true then return ... end` line.
- If a file has `WARN: THIS FILE IS ACTIVATED` (such as `mason.lua`, `treesitter.lua`), do not re-add an early-exit guard.

### 2. Adding New Plugins
- **DO NOT** edit `init.lua` to add plugins.
- **DO NOT** clutter `lua/lazy_setup.lua`.
- **DO** create a dedicated file in `lua/plugins/<plugin-name>.lua`.
- Standard plugin spec structure:
  ```lua
  ---@type LazySpec
  return {
    "author/repository-name",
    event = "BufReadPost", -- or specific trigger
    opts = {
      -- configuration options passed to require("plugin").setup(...)
    },
  }
  ```
- If overriding an existing AstroNvim plugin, extend `opts`:
  ```lua
  return {
    "plugin/name",
    opts = function(_, opts)
      opts.some_setting = true
      return opts
    end,
  }
  ```

### 3. Preserving Cross-Platform Compatibility
This configuration is used on both **Linux** and **Windows** (via Git Bash). When adding file paths, system commands, or external executable calls:
- Avoid hardcoding `/` or `\`. Detect separator with:
  ```lua
  local path_sep = package.config:sub(1, 1)
  local is_windows = path_sep == "\\"
  ```
- When resolving virtual environment binaries, account for `Scripts/` vs `bin/`:
  ```lua
  local bin_dir = is_windows and "Scripts" or "bin"
  local exe_suffix = is_windows and ".exe" or ""
  ```
- Never break the Windows Git Bash shell overrides in `lua/config/options.lua`.

### 4. Code Formatting & Linting Rules
Always adhere to the repo's formatting standards defined in `.stylua.toml`:
- **Indent**: 2 spaces
- **Column Width**: 120 characters
- **Quotes**: Double quotes preferred (`AutoPreferDouble`)
- **Call Parentheses**: `None` where idiomatic in Lua (e.g. `require "module"`, `opts { ... }`)
- **Linter**: `selene.toml` with `std = "neovim"` (allows globals, mixed tables, multiple statements).

### 5. Git Commit Guidelines
Follow the Conventional Commits specification used in the repository history:
- `feat: <description>` for new capabilities or keymaps
- `fix: <description>` for bug fixes and compatibility adjustments
- `chore: <description>` for dependency updates, assets, and housekeeping

---

## 6. Verification & Health Checks

When making changes to Lua configurations, verify syntax and execution integrity before concluding work:

1. **Headless Startup Test** (verifies syntax and startup execution without crashing):
   ```bash
   nvim --headless -c "quit"
   ```
   If there is a Lua syntax error or invalid `require`, this will output the traceback and exit with a non-zero code.

2. **Check Deprecations & Health**:
   ```bash
   nvim --headless -c "checkhealth" -c "quit"
   ```

3. **Check Git Status**:
   ```bash
   git status
   ```
   Note: `lazy-lock.json` may change if plugins update; do not commit unintended lockfile changes unless updating dependencies.
