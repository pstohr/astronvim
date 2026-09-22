local ok, catppuccin = pcall(require, "catppuccin")
if not ok then return end

catppuccin.setup {
  flavour = "mocha",
  transparent_background = true, -- Inherits your terminal opacity & blur
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
    neotree = true,
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
      style = "nvchad",
    },
  },
}

-- Set colorscheme
vim.cmd.colorscheme "catppuccin"
