local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local general_group = augroup("GeneralSettings", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
  group = general_group,
  desc = "Highlight text on yank",
  callback = function() vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 } end,
})

-- Return to last edit position when opening files
autocmd("BufReadPost", {
  group = general_group,
  desc = "Return to last edit position",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

-- Native vim.pack build hooks
autocmd("PackChanged", {
  group = augroup("PackHooks", { clear = true }),
  desc = "Run plugin build hooks on install or update",
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind

    if (kind == "install" or kind == "update") and ev.data.path then
      -- Build telescope-fzf-native
      if name == "telescope-fzf-native.nvim" then
        vim.notify("Building telescope-fzf-native...", vim.log.levels.INFO)
        vim.system({ "make" }, { cwd = ev.data.path }, function(res)
          vim.schedule(function()
            if res.code == 0 then
              vim.notify("telescope-fzf-native built successfully!", vim.log.levels.INFO)
            else
              vim.notify("telescope-fzf-native build failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
            end
          end)
        end)
      end

      -- Update Treesitter parsers
      if name == "nvim-treesitter" then pcall(vim.cmd, "TSUpdate") end
    end
  end,
})
