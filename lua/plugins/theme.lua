return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- Ensure catppuccin is loaded at startup so AstroUI can apply it
    priority = 1000, -- Load this first
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true, -- Inherits your Alacritty opacity & blur
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = { "italic" },
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          native_lsp = { enabled = true },
          mason = true,
          notify = true,
          which_key = true,
          dap = true,
          dap_ui = true,
          neogit = true,
          telescope = {
            enabled = true,
            style = "nvchad", -- Gives telescope a sleek, borderless modern look
          },
        },
      })

      -- Set the colorscheme
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
