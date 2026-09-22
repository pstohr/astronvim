-- Gitsigns
local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
if gitsigns_ok then
  gitsigns.setup {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]h", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Next Git Hunk" })

      map("n", "[h", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Previous Git Hunk" })

      -- Actions
      map("n", "<Leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
      map("n", "<Leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
      map("n", "<Leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
      map("n", "<Leader>hb", function() gs.blame_line { full = true } end, { desc = "Blame Line" })
      map("n", "<Leader>hd", gs.diffthis, { desc = "Diff This" })
    end,
  }
end

-- Diffview
local diffview_ok, diffview = pcall(require, "diffview")
if diffview_ok then diffview.setup {} end

-- Neogit
local neogit_ok, neogit = pcall(require, "neogit")
if neogit_ok then
  neogit.setup {
    integrations = {
      diffview = true,
      telescope = true,
    },
    disable_commit_confirmation = true,
  }
end
