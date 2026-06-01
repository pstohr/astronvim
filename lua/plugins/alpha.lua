return {
  "goolord/alpha-nvim",
  opts = function(_, opts)
    -- 1. Define Modern deeply-extruded ASCII Art
    local header_art = {
      [[        /\ \      /\ \     /\ \          ]],
      [[       \  \ \    /  \ \   /  \ \         ]],
      [[        \  \ \  / /\ \ \ / /\ \ \        ]],
      [[         \  \ \/ /  \ \ \/ /  \ \ \      ]],
      [[          \  \  /    \ \  /    \ \ \     ]],
      [[           \   /      \  /      \ \ \    ]],
      [[            \ /        \/        \ \ \   ]],
      [[            / \                  / / /   ]],
      [[           /   \                / / /    ]],
      [[          /  /\ \              / / /     ]],
      [[         /  /  \ \            / / /      ]],
      [[        /  / /\ \ \__________/ / /       ]],
      [[       /  / /  \ \__________/ / /        ]],
      [[       \/_/     \/_________/ /_/         ]],
    }

    -- 2. Dynamic Greeting based on time of day
    local function get_greeting()
      local hour = tonumber(os.date("%H"))
      local greeting = "Welcome back, Pim!"
      if hour < 12 then
        greeting = "🌅 Good morning, Pim. Ready to build something amazing?"
      elseif hour < 18 then
        greeting = "☀️ Good afternoon, Pim. Happy coding!"
      else
        greeting = "🌙 Good evening, Pim. Code late, think deep."
      end
      return { "", greeting, "" }
    end

    local header_val = {}
    for _, line in ipairs(header_art) do
      table.insert(header_val, line)
    end
    for _, line in ipairs(get_greeting()) do
      table.insert(header_val, line)
    end

    opts.section.header.val = header_val

    -- Custom byte-accurate character-level highlight parser
    local function parse_wireframe_highlights(line, red_hl, blue_hl, green_hl)
      local hls = {}
      local i = 1
      local len = #line
      while i <= len do
        local c = line:sub(i, i)
        if c == " " then
          i = i + 1
        else
          local start_idx = i - 1
          local col = i -- 1-indexed column number
          local hl_group = red_hl
          if col > 26 then
            hl_group = green_hl
          elseif col > 15 then
            hl_group = blue_hl
          end

          while i <= len and line:sub(i, i) ~= " " do
            i = i + 1
          end
          local end_idx = i - 1
          table.insert(hls, { hl_group, start_idx, end_idx })
        end
      end
      return hls
    end

    -- Calculate gradient highlight groups per line for the ASCII art,
    -- with character-level 3D side/shadow highlighting.
    local hl_table = {}
    for i, line in ipairs(header_art) do
      local parsed = parse_wireframe_highlights(line, "DashboardHeaderRed", "DashboardHeaderBlue", "DashboardHeaderGreen")
      table.insert(hl_table, parsed)
    end

    local greeting = get_greeting()
    for _, line in ipairs(greeting) do
      if #line > 0 then
        table.insert(hl_table, { { "DashboardCenter", 0, #line } })
      else
        table.insert(hl_table, {})
      end
    end

    opts.section.header.opts.hl = hl_table

    -- 3. Custom Premium Buttons
    local get_icon = require("astroui").get_icon
    opts.section.buttons.val = {
      opts.button("LDR f f", get_icon("Search", 2, true) .. "Find File  ", "<cmd>Telescope find_files<cr>"),
      opts.button("LDR f o", get_icon("DefaultFile", 2, true) .. "Recent Files  ", "<cmd>Telescope oldfiles<cr>"),
      opts.button("LDR f w", get_icon("WordFile", 2, true) .. "Find Word  ", "<cmd>Telescope live_grep<cr>"),
      opts.button("LDR n  ", get_icon("FileNew", 2, true) .. "New File  ", "<cmd>ene <BAR> startinsert <cr>"),
      opts.button("LDR S l", get_icon("Refresh", 2, true) .. "Last Session  ", "<cmd>SessionManager load_last_session<cr>"),
      opts.button("LDR g g", get_icon("Git", 2, true) .. "Git Status  ", "<cmd>Neogit<cr>"),
      opts.button("LDR f c", "  Open Config  ", "<cmd>edit ~/.config/nvim/init.lua<cr>"),
      opts.button("LDR l  ", get_icon("Package", 2, true) .. "Lazy Manager  ", "<cmd>Lazy<cr>"),
      opts.button("q      ", "  Quit  ", "<cmd>qa<cr>"),
    }

    -- 4. Set layout
    opts.config.layout = {
      { type = "padding", val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.18) } },
      opts.section.header,
      { type = "padding", val = 3 },
      opts.section.buttons,
      { type = "padding", val = 2 },
      opts.section.footer,
    }

    return opts
  end,
  config = function(plugin, opts)
    -- Setup highlights
    local function set_highlights()
      local colors = {
        mauve = "#cba6f7",
        blue = "#89b4fa",
        teal = "#8bd5ca",
        green = "#a6e3a1",
        lavender = "#b4befe",
        red = "#f38ba8",
        overlay0 = "#6c7086",
        text = "#cdd6f4",
      }
      vim.api.nvim_set_hl(0, "DashboardHeader", { fg = colors.mauve, bold = true })
      vim.api.nvim_set_hl(0, "DashboardHeaderRed", { fg = colors.red, bold = true })
      vim.api.nvim_set_hl(0, "DashboardHeaderMauve", { fg = colors.mauve, bold = true })
      vim.api.nvim_set_hl(0, "DashboardHeaderLavender", { fg = colors.lavender, bold = true })
      vim.api.nvim_set_hl(0, "DashboardHeaderBlue", { fg = colors.blue, bold = true })
      vim.api.nvim_set_hl(0, "DashboardHeaderTeal", { fg = colors.teal, bold = true })
      vim.api.nvim_set_hl(0, "DashboardHeaderGreen", { fg = colors.green, bold = true })
      vim.api.nvim_set_hl(0, "DashboardHeaderShadow", { fg = "#45475a", bold = true })
      vim.api.nvim_set_hl(0, "DashboardCenter", { fg = colors.text })
      vim.api.nvim_set_hl(0, "DashboardShortcut", { fg = colors.red, bold = true })
      vim.api.nvim_set_hl(0, "DashboardFooter", { fg = colors.overlay0, italic = true })
    end

    set_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = set_highlights,
    })

    -- Call standard setup
    require("alpha").setup(opts.config)

    -- Custom User autocommand for lazy loading of the footer
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      desc = "Add Alpha dashboard footer with stats and random quotes",
      once = true,
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        
        -- Custom modern quotes list
        local quotes = {
          "\"Simplify, then add lightness.\" — Colin Chapman",
          "\"First, solve the problem. Then, write the code.\" — John Johnson",
          "\"Make it work, make it right, make it fast.\" — Kent Beck",
          "\"Strive for simplicity; simplicity is the soul of modern art.\"",
          "\"Talk is cheap. Show me the code.\" — Linus Torvalds",
          "\"Stay hungry, stay foolish.\" — Steve Jobs",
          "\"Simplicity is the ultimate sophistication.\" — Leonardo da Vinci",
          "\"Control-Alt-Delete your doubts.\"",
        }
        math.randomseed(os.time())
        local random_quote = quotes[math.random(#quotes)]
        
        local package_icon = require("astroui").get_icon("Package", 1, true)
        local stats_str = "⚡ Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins " .. package_icon .. "in " .. ms .. "ms"
        
        opts.section.footer.val = {
          stats_str,
          "",
          random_quote,
        }
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
