local ok, telescope = pcall(require, "telescope")
if not ok then return end

local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
      },
      n = {
        ["q"] = actions.close,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
    },
  },
}

-- Load fzf native if compiled
pcall(telescope.load_extension, "fzf")
