-- Mason & Mason-LSPConfig
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
  mason.setup {
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  }
end

local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
if mason_lsp_ok then mason_lsp.setup {
  ensure_installed = { "lua_ls" },
  automatic_installation = false,
} end

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then return end

-- Capabilities with nvim-cmp support
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_lsp_ok then capabilities = cmp_nvim_lsp.default_capabilities(capabilities) end

-- Diagnostic formatting & icons
vim.diagnostic.config {
  virtual_text = true,
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
}

local path_sep = package.config:sub(1, 1)
local is_windows = path_sep == "\\"
local bin_dir = is_windows and "Scripts" or "bin"
local exe_suffix = is_windows and ".exe" or ""

-- Common root dir pattern for Python
local function python_root_dir(fname)
  local util = require "lspconfig.util"
  local root = util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile")(fname)
  if not root then root = util.root_pattern "api"(fname) end
  return root
end

-- Common on_attach function
local on_attach = function(client, bufnr)
  local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end

  map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to Declaration")
  map("n", "gd", vim.lsp.buf.definition, "LSP: Go to Definition")
  map("n", "K", vim.lsp.buf.hover, "LSP: Hover Info")
  map("n", "gi", vim.lsp.buf.implementation, "LSP: Go to Implementation")
  map("n", "gr", vim.lsp.buf.references, "LSP: Go to References")
  map("n", "<Leader>lr", vim.lsp.buf.rename, "LSP: Rename Symbol")
  map("n", "<Leader>la", vim.lsp.buf.code_action, "LSP: Code Action")
  map("n", "<Leader>lf", function() vim.lsp.buf.format { timeout_ms = 1000 } end, "LSP: Format Document")

  -- Codelens refresh
  if client.supports_method "textDocument/codeLens" then
    local codelens_group = vim.api.nvim_create_augroup("LspCodeLens_" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
      group = codelens_group,
      buffer = bufnr,
      callback = function() vim.lsp.codelens.refresh { bufnr = bufnr } end,
    })
  end
end

-- 1. Lua Language Server
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
      format = { enable = false }, -- Let StyLua handle formatting
    },
  },
}

-- 2. Ruff (Python Linter & Formatter)
lspconfig.ruff.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "uvx", "ruff", "server" },
  root_dir = python_root_dir,
  on_new_config = function(new_config, new_root_dir)
    if vim.fn.executable "uvx" == 1 then
      new_config.cmd = { "uvx", "ruff", "server" }
    elseif new_root_dir then
      local venv_ruff = new_root_dir .. path_sep .. "venv" .. path_sep .. bin_dir .. path_sep .. "ruff" .. exe_suffix
      local dot_venv_ruff = new_root_dir
        .. path_sep
        .. ".venv"
        .. path_sep
        .. bin_dir
        .. path_sep
        .. "ruff"
        .. exe_suffix
      if vim.fn.executable(venv_ruff) == 1 then
        new_config.cmd = { venv_ruff, "server" }
      elseif vim.fn.executable(dot_venv_ruff) == 1 then
        new_config.cmd = { dot_venv_ruff, "server" }
      end
    end
  end,
}

-- 3. Ty (Python Typechecker)
lspconfig.ty.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "uvx", "ty", "server" },
  filetypes = { "python" },
  root_dir = python_root_dir,
  on_new_config = function(new_config, new_root_dir)
    if vim.fn.executable "uvx" == 1 then
      new_config.cmd = { "uvx", "ty", "server" }
    elseif new_root_dir then
      local venv_ty = new_root_dir .. path_sep .. "venv" .. path_sep .. bin_dir .. path_sep .. "ty" .. exe_suffix
      local dot_venv_ty = new_root_dir .. path_sep .. ".venv" .. path_sep .. bin_dir .. path_sep .. "ty" .. exe_suffix
      if vim.fn.executable(venv_ty) == 1 then
        new_config.cmd = { venv_ty, "server" }
      elseif vim.fn.executable(dot_venv_ty) == 1 then
        new_config.cmd = { dot_venv_ty, "server" }
      end
    end
  end,
}

-- 4. Pylsp (Python Language Server for completions with rope)
lspconfig.pylsp.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = python_root_dir,
  settings = {
    pylsp = {
      plugins = {
        autopep8 = { enabled = false },
        pycodestyle = { enabled = false },
        flake8 = { enabled = false },
        pyflakes = { enabled = false },
        rope_completion = { enabled = true },
      },
    },
  },
}

-- Global Format on Save
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Format on save (ruff for python, stylua for lua)",
  callback = function()
    local ft = vim.bo.filetype
    if ft == "python" then
      vim.lsp.buf.format {
        filter = function(client) return client.name == "ruff" end,
        timeout_ms = 1000,
      }
    elseif ft == "lua" then
      vim.lsp.buf.format {
        filter = function(client) return client.name ~= "lua_ls" end,
        timeout_ms = 1000,
      }
    end
  end,
})
