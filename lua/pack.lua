-- Configure packpath so native vim.pack can discover packages in stdpath("data")/site
local site_dir = vim.fn.stdpath "data" .. "/site"
if not vim.opt.packpath:get()[site_dir] then vim.opt.packpath:prepend(site_dir) end

local function gh(repo) return "https://github.com/" .. repo end

-- Declare all plugins managed by native vim.pack
vim.pack.add({
  -- Theme & UI
  gh "catppuccin/nvim",
  gh "nvim-lualine/lualine.nvim",
  gh "nvim-tree/nvim-web-devicons",
  gh "goolord/alpha-nvim",
  gh "rcarriga/nvim-notify",
  gh "folke/which-key.nvim",
  gh "lukas-reineke/indent-blankline.nvim",
  gh "akinsho/bufferline.nvim",

  -- Treesitter & Syntax
  gh "nvim-treesitter/nvim-treesitter",
  gh "nvim-treesitter/nvim-treesitter-textobjects",
  gh "windwp/nvim-autopairs",
  gh "numToStr/Comment.nvim",

  -- Navigation & Fuzzy Finder
  gh "nvim-lua/plenary.nvim",
  gh "nvim-telescope/telescope.nvim",
  gh "nvim-telescope/telescope-fzf-native.nvim",

  -- File Explorer
  gh "MunifTanjim/nui.nvim",
  gh "nvim-neo-tree/neo-tree.nvim",

  -- Git
  gh "NeogitOrg/neogit",
  gh "sindrets/diffview.nvim",
  gh "lewis6991/gitsigns.nvim",

  -- Terminal
  gh "akinsho/toggleterm.nvim",

  -- LSP & Tooling
  gh "neovim/nvim-lspconfig",
  gh "williamboman/mason.nvim",
  gh "williamboman/mason-lspconfig.nvim",

  -- Completion, Snippets & AI
  gh "hrsh7th/nvim-cmp",
  gh "hrsh7th/cmp-nvim-lsp",
  gh "hrsh7th/cmp-buffer",
  gh "hrsh7th/cmp-path",
  gh "saadparwaiz1/cmp_luasnip",
  gh "L3MON4D3/LuaSnip",
  gh "rafamadriz/friendly-snippets",
  gh "saecki/crates.nvim",
  gh "zbirenbaum/copilot.lua",

  -- DAP (Debugging)
  gh "mfussenegger/nvim-dap",
  gh "rcarriga/nvim-dap-ui",
  gh "nvim-neotest/nvim-nio",
  gh "jay-babu/mason-nvim-dap.nvim",

  -- Session
  gh "stevearc/resession.nvim",
}, { confirm = false })
