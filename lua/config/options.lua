-- Enable true color support
vim.opt.termguicolors = true

-- On Windows, when using a bash-like shell, cmd.exe's "/s /c" flags are
-- nonsense to bash and cause "no file /s" on terminal open.
if vim.fn.has "win32" == 1 then
  vim.opt.shell = "C:\\Program Files\\Git\\bin\\bash.exe -i -l" -- Use Git Bash as the default shell
  vim.opt.shellcmdflag = "-s"
end

-- UI & Editor options
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative numbers for easier jumping
vim.opt.signcolumn = "yes" -- Always show the sign column so text doesn't jump
vim.opt.cursorline = true -- Highlight current line
vim.opt.wrap = false -- Disable line wrap by default
vim.opt.scrolloff = 8 -- Minimum screen lines above/below cursor
vim.opt.sidescrolloff = 8 -- Minimum screen columns to left/right of cursor
vim.opt.mouse = "a" -- Enable mouse support

-- Indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.softtabstop = 2
vim.opt.smartindent = true -- Insert indents automatically

-- Search settings
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override ignorecase if search pattern has uppercase
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Window splits
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current

-- Timing & undo
vim.opt.updatetime = 250 -- Faster completion & updates
vim.opt.timeoutlen = 300 -- Faster key sequence timeout
vim.opt.undofile = true -- Persistent undo history

-- Globally force floating/LSP windows to use rounded borders
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded" -- Adds standard modern rounded borders
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
