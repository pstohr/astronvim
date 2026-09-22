local ok, neotree = pcall(require, "neo-tree")
if not ok then return end

neotree.setup {
  close_if_last_window = true,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "󰉖",
      default = "*",
    },
    git_status = {
      symbols = {
        added = "✚",
        modified = "",
        deleted = "✖",
        renamed = "󰁕",
        untracked = "",
        ignored = "",
        unstaged = "󰄱",
        staged = "",
        conflict = "",
      },
    },
  },
  window = {
    position = "left",
    width = 32,
    mappings = {
      ["<space>"] = "none",
      ["o"] = "open",
      ["s"] = "open_split",
      ["v"] = "open_vsplit",
      ["C"] = "close_node",
      ["z"] = "close_all_nodes",
      ["R"] = "refresh",
      ["a"] = "add",
      ["d"] = "delete",
      ["r"] = "rename",
      ["c"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
    },
  },
  filesystem = {
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = {
      enabled = true,
    },
    use_libuv_file_watcher = true,
  },
}
