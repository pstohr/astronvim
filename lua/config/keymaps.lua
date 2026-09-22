-- Global leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local map = vim.keymap.set

-- Clear search highlight on pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Buffer navigation
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<Leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<Leader>c", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- File Explorer (Neo-tree)
map("n", "<Leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle Explorer" })
map("n", "<Leader>o", "<cmd>Neotree focus<CR>", { desc = "Focus Explorer" })

-- Telescope Keymaps
map("n", "<Leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<Leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent Files" })
map("n", "<Leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Find Word (grep)" })
map("n", "<Leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find Buffers" })
map("n", "<Leader>fc", "<cmd>edit ~/.config/nvim/init.lua<CR>", { desc = "Open Config" })

-- Git Keymaps
map("n", "<Leader>gg", "<cmd>Neogit<CR>", { desc = "Open Neogit" })

-- Native Pack Manager shortcuts
map("n", "<Leader>pu", "<cmd>lua vim.pack.update()<CR>", { desc = "Pack: Update plugins" })
map("n", "<Leader>ps", "<cmd>lua vim.print(vim.pack.get())<CR>", { desc = "Pack: Status / List plugins" })
map("n", "<Leader>pc", function()
  local inactive = vim
    .iter(vim.pack.get())
    :filter(function(x) return not x.active end)
    :map(function(x) return x.spec.name end)
    :totable()
  if #inactive > 0 then
    vim.pack.del(inactive)
    vim.notify("Removed " .. #inactive .. " inactive plugins", vim.log.levels.INFO)
  else
    vim.notify("No inactive plugins to remove", vim.log.levels.INFO)
  end
end, { desc = "Pack: Clean inactive plugins" })
