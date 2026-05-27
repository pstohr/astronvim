return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      on_create = function(term)
        if vim.fn.has("win32") == 1 then
          term:send("%USERPROFILE%\\Apps\\CMDER\\vendor\\init.bat")
          term:clear()
        end
      end,
    },
    keys = {
       {
        "jk",
        [[<C-\><C-n>]],
        mode = "t",
        desc = "Exit terminal mode",
      },
      {
        "<esc>",
        [[<C-\><C-n>]],
        mode = "t",
        desc = "Exit terminal mode",
      },
      -- Window navigation mappings in terminal mode
      {
        "<C-h>",
        [[<Cmd>wincmd h<CR>]],
        mode = "t",
        desc = "Go to left window",
      },
      {
        "<C-j>",
        [[<Cmd>wincmd j<CR>]],
        mode = "t",
        desc = "Go to lower window",
      },
      {
        "<C-k>",
        [[<Cmd>wincmd k<CR>]],
        mode = "t",
        desc = "Go to upper window",
      },
      {
        "<C-l>",
        [[<Cmd>wincmd l<CR>]],
        mode = "t",
        desc = "Go to right window",
      },
      -- Close window mapping in terminal mode
      {
        "<C-w>",
        [[<C-d>]],
        mode = "t",
        desc = "Close window",
      },
    }
  },
}
