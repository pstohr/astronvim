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

  -- Disable heirline (default AstroNvim statusline) to prevent conflicts with lualine
  { "rebelot/heirline.nvim", enabled = false },
}
