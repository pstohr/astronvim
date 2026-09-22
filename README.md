# Neovim Configuration

A clean, modern, ultra-fast **Neovim (v0.12+)** configuration using Neovim's built-in native package manager (**`vim.pack`**).

## ✨ Features

- **Package Management**: Native Neovim 0.12 package management (`vim.pack`) with declarative dependencies and lockfile (`nvim-pack-lock.json`).
- **Aesthetics & Theme**: Catppuccin Mocha with transparent background, custom italics, Lualine statusline, Bufferline tabs, and custom 3D ASCII art Alpha dashboard.
- **Language Server Protocol (LSP)**: Built-in `nvim-lspconfig` and Mason for managing tools. First-class support for `ruff`, `ty`, `pylsp`, and `lua_ls` with format-on-save.
- **Autocompletion & AI**: `nvim-cmp`, `LuaSnip`, and `copilot.lua` with intelligent `<Tab>` chaining.
- **Debugging (DAP)**: `nvim-dap` and `nvim-dap-ui` with Python `debugpy` and pytest test-runner integrations.
- **Git & Terminal**: `Neogit`, `Diffview`, `Gitsigns`, and `ToggleTerm` with direct window navigation.

## 📦 Managing Plugins

- **Update Plugins**: Run `:lua vim.pack.update()` or press `<Leader>pu`. An interactive diff buffer will open; press `:w` to confirm updates or `:q` to cancel.
- **Plugin Status**: Run `:lua vim.print(vim.pack.get())` or press `<Leader>ps`.
- **Clean Inactive Plugins**: Press `<Leader>pc`.
