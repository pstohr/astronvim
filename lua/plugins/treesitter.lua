local ts_ok, ts = pcall(require, "nvim-treesitter.configs")
if ts_ok then
  ts.setup {
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "python",
      "rust",
      "bash",
      "markdown",
      "markdown_inline",
      "json",
      "yaml",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
  }
end

-- Autopairs
local autopairs_ok, autopairs = pcall(require, "nvim-autopairs")
if autopairs_ok then autopairs.setup {
  check_ts = true,
} end

-- Comment
local comment_ok, comment = pcall(require, "Comment")
if comment_ok then comment.setup() end
