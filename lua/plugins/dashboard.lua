local ok, alpha = pcall(require, "alpha")
if not ok then return end

local dashboard = require "alpha.themes.dashboard"

-- 1. Modern deeply-extruded ASCII Art
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
  local hour = tonumber(os.date "%H")
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

local hl_table = {}
for _, line in ipairs(header_art) do
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

-- 3. Custom Premium Buttons
dashboard.section.buttons.val = {
  dashboard.button("f", "  Find File", "<cmd>Telescope find_files<cr>"),
  dashboard.button("o", "  Recent Files", "<cmd>Telescope oldfiles<cr>"),
  dashboard.button("w", "󰈞  Find Word", "<cmd>Telescope live_grep<cr>"),
  dashboard.button("n", "  New File", "<cmd>ene <BAR> startinsert <cr>"),
  dashboard.button("g", "󰊢  Git Status", "<cmd>Neogit<cr>"),
  dashboard.button("c", "  Open Config", "<cmd>edit ~/.config/nvim/init.lua<cr>"),
  dashboard.button("p", "󰏓  Pack Manager", "<cmd>lua vim.pack.update()<cr>"),
  dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
}

dashboard.section.header.val = header_val
dashboard.section.header.opts.hl = hl_table

-- 4. Layout
dashboard.config.layout = {
  { type = "padding", val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.18) } },
  dashboard.section.header,
  { type = "padding", val = 3 },
  dashboard.section.buttons,
  { type = "padding", val = 2 },
  dashboard.section.footer,
}

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

-- Random quotes list
local quotes = {
  '"Simplify, then add lightness." — Colin Chapman',
  '"First, solve the problem. Then, write the code." — John Johnson',
  '"Make it work, make it right, make it fast." — Kent Beck',
  '"Strive for simplicity; simplicity is the soul of modern art."',
  '"Talk is cheap. Show me the code." — Linus Torvalds',
  '"Stay hungry, stay foolish." — Steve Jobs',
  '"Simplicity is the ultimate sophistication." — Leonardo da Vinci',
  '"Control-Alt-Delete your doubts."',
}
math.randomseed(os.time())
local random_quote = quotes[math.random(#quotes)]

local count = #vim.pack.get()
local stats_str = "⚡ Loaded " .. count .. " plugins (native pack) " .. "󰏓"

dashboard.section.footer.val = {
  stats_str,
  "",
  random_quote,
}

alpha.setup(dashboard.config)
