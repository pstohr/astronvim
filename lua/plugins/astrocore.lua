-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- Debugger mappings
        ["<Leader>d"] = { desc = "Debugger" },
        ["<Leader>db"] = { function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
        ["<Leader>dB"] = {
          function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Conditional breakpoint",
        },
        ["<Leader>dc"] = { function() require("dap").continue() end, desc = "Continue/Start debugging" },
        ["<Leader>di"] = { function() require("dap").step_into() end, desc = "Step into" },
        ["<Leader>do"] = { function() require("dap").step_over() end, desc = "Step over" },
        ["<Leader>dO"] = { function() require("dap").step_out() end, desc = "Step out" },
        ["<Leader>dq"] = { function() require("dap").terminate() end, desc = "Terminate" },
        ["<Leader>dr"] = { function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
        ["<Leader>ds"] = { function() require("dap").continue() end, desc = "Start/Continue" },
        ["<Leader>du"] = { function() require("dapui").toggle() end, desc = "Toggle debugger UI" },
        ["<Leader>dh"] = { function() require("dap.ui.widgets").hover() end, desc = "Debugger hover" },
        ["<Leader>dp"] = { function() require("dap").pause() end, desc = "Pause" },
        ["<Leader>dR"] = { function() require("dap").run_to_cursor() end, desc = "Run to cursor" },

        -- Python-specific debug mappings
        ["<Leader>dpt"] = {
          function()
            require("dap-python").test_method()
          end,
          desc = "Debug Python test method",
        },
        ["<Leader>dpc"] = {
          function()
            require("dap-python").test_class()
          end,
          desc = "Debug Python test class",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
      -- Visual mode mappings for debugger
      v = {
        ["<Leader>d"] = { desc = "Debugger" },
        ["<Leader>de"] = {
          function()
            require("dapui").eval()
          end,
          desc = "Evaluate expression",
        },
      },
    },
  },
}
