-- Ensure native pack directory in stdpath("data")/site is in packpath
local site_dir = vim.fn.stdpath "data" .. "/site"
if not vim.opt.packpath:get()[site_dir] then vim.opt.packpath:prepend(site_dir) end

-- Core configuration
require "config.options"
require "config.keymaps"
require "config.autocmds"

-- Native package manager (vim.pack)
require "pack"

-- Plugin setups
require "plugins.theme"
require "plugins.ui"
require "plugins.treesitter"
require "plugins.telescope"
require "plugins.neo-tree"
require "plugins.git"
require "plugins.toggleterm"
require "plugins.lsp"
require "plugins.completion"
require "plugins.dap"
require "plugins.dashboard"
