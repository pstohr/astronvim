-- Web Devicons
local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
if devicons_ok then devicons.setup { default = true } end

-- Notify
local notify_ok, notify = pcall(require, "notify")
if notify_ok then
  notify.setup {
    background_colour = "#000000",
    timeout = 3000,
    stages = "fade",
  }
  vim.notify = notify
end

-- Lualine (Modern status bar)
local lualine_ok, lualine = pcall(require, "lualine")
if lualine_ok then
  lualine.setup {
    options = {
      theme = "catppuccin-mocha",
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "░", right = "░" },
      globalstatus = true,
    },
  }
end

-- Bufferline (Modern buffer tabs at top of screen)
local bufferline_ok, bufferline = pcall(require, "bufferline")
if bufferline_ok then
  bufferline.setup {
    options = {
      mode = "buffers",
      numbers = "none",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          text_align = "center",
          separator = true,
        },
      },
    },
  }
end

-- Which-key
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then wk.setup {} end

-- Indent Blankline
local ibl_ok, ibl = pcall(require, "ibl")
if ibl_ok then ibl.setup {
  indent = { char = "│" },
  scope = { enabled = true },
} end
