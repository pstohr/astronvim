-- Enable true color support
vim.opt.termguicolors = true

-- Modern UI choices
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative numbers for easier jumping
vim.opt.signcolumn = "yes"    -- Always show the sign column so text doesn't jump

-- Globally force floating/LSP windows to use rounded borders
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded" -- Adds standard modern rounded borders
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
