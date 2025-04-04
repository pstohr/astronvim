return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      on_create = function(term)
        term:send("%USERPROFILE%\\Apps\\CMDER\\vendor\\init.bat")
        term:clear()
      end,
    }
  },
}
