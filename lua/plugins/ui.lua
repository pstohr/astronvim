return {
  -- Web Devicons for modern file type icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Lualine (Modern status bar)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin-mocha", -- Must match the flavour set in theme.lua
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "░", right = "░" }, -- or use modern slope/arrow glyphs
          globalstatus = true, -- Single statusline at the bottom of the screen
        },
      })
    end,
  },

  -- Configure heirline to disable the default statusline (to prevent conflicts with lualine)
  -- while keeping the tabline (top buffer tabs) enabled.
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      opts.statusline = nil
      return opts
    end,
  },
}
