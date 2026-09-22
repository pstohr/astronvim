local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then return end

local luasnip_ok, luasnip = pcall(require, "luasnip")
if luasnip_ok then
  -- Load friendly-snippets if available
  pcall(function() require("luasnip.loaders.from_vscode").lazy_load() end)
end

-- Icons for completion menu
local symbol_kinds = {
  Class = "",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Keyword = "",
  Method = "",
  Module = "",
  Operator = "",
  Property = "",
  Reference = "",
  Snippet = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "",
}

-- Inside a snippet, use backspace to remove the placeholder
vim.keymap.set("s", "<BS>", "<C-O>s")

-- Setup Copilot
local copilot_ok, copilot = pcall(require, "copilot")
if copilot_ok then
  copilot.setup {
    panel = { enabled = false },
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = false, -- Handled via <Tab> in cmp
        accept_word = "<M-w>",
        accept_line = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "/",
      },
    },
    filetypes = { markdown = true },
  }

  local copilot_suggestion = require "copilot.suggestion"
  local function set_trigger(trigger)
    vim.b.copilot_suggestion_auto_trigger = trigger
    vim.b.copilot_suggestion_hidden = not trigger
  end

  -- Hide suggestions when the completion menu is open
  cmp.event:on("menu_opened", function()
    if copilot_suggestion.is_visible() then copilot_suggestion.dismiss() end
    set_trigger(false)
  end)

  -- Restore suggestions when completion menu closes
  cmp.event:on("menu_closed", function()
    local inside_snippet = luasnip_ok and luasnip.expand_or_locally_jumpable() or false
    set_trigger(not inside_snippet)
  end)

  if luasnip_ok then
    vim.api.nvim_create_autocmd("User", {
      pattern = { "LuasnipInsertNodeEnter", "LuasnipInsertNodeLeave" },
      callback = function() set_trigger(not luasnip.expand_or_locally_jumpable()) end,
    })
  end
end

-- Setup Crates.nvim if available
local crates_ok, crates = pcall(require, "crates")
if crates_ok then crates.setup() end

-- Setup nvim-cmp
cmp.setup {
  preselect = cmp.PreselectMode.None,
  formatting = {
    format = function(_, vim_item)
      vim_item.kind = (symbol_kinds[vim_item.kind] or "") .. "  " .. vim_item.kind
      return vim_item
    end,
  },
  snippet = {
    expand = function(args)
      if luasnip_ok then luasnip.lsp_expand(args.body) end
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  view = {
    docs = { auto_open = false },
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<C-Space>"] = cmp.mapping.complete(),
    ["/"] = cmp.mapping.close(),
    -- Tab overload: Copilot -> CMP -> Snippet -> Tab indent
    ["<Tab>"] = cmp.mapping(function(fallback)
      local copilot_sug = pcall(require, "copilot.suggestion") and require "copilot.suggestion"
      if copilot_sug and copilot_sug.is_visible() then
        copilot_sug.accept()
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif luasnip_ok and luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip_ok and luasnip.expand_or_locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-d>"] = function()
      if cmp.visible_docs() then
        cmp.close_docs()
      else
        cmp.open_docs()
      end
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "crates" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
}
