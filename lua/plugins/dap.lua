local dap_ok, dap = pcall(require, "dap")
if not dap_ok then return end

local path_sep = package.config:sub(1, 1)
local is_windows = path_sep == "\\"
local mason_path = vim.fn.stdpath "data" .. path_sep .. "mason"
local bin_dir = is_windows and "Scripts" or "bin"
local python_exe = is_windows and "python.exe" or "python"

-- Mason DAP integration
local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")
if mason_dap_ok then mason_dap.setup {
  ensure_installed = { "python" },
  automatic_installation = true,
} end

-- Python adapter command resolution
local mason_debugpy = mason_path
  .. path_sep
  .. "packages"
  .. path_sep
  .. "debugpy"
  .. path_sep
  .. ".venv"
  .. path_sep
  .. bin_dir
  .. path_sep
  .. python_exe

local adapter_command = vim.fn.executable(mason_debugpy) == 1 and mason_debugpy or "/usr/bin/python3"

dap.adapters.python = {
  type = "executable",
  command = adapter_command,
  args = { "-m", "debugpy.adapter" },
}

-- Python path resolver
local function resolve_python()
  local cwd = vim.fn.getcwd()
  local venv_py = cwd .. path_sep .. "venv" .. path_sep .. bin_dir .. path_sep .. python_exe
  local dot_venv_py = cwd .. path_sep .. ".venv" .. path_sep .. bin_dir .. path_sep .. python_exe

  if vim.fn.executable(venv_py) == 1 then
    return venv_py
  elseif vim.fn.executable(dot_venv_py) == 1 then
    return dot_venv_py
  else
    return python_exe
  end
end

-- Python run configurations
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = resolve_python,
  },
  {
    type = "python",
    request = "launch",
    name = "Run pytest",
    module = "pytest",
    args = { "${file}" },
    pythonPath = resolve_python,
  },
  {
    type = "python",
    request = "launch",
    name = "Run pytest (test case)",
    module = "pytest",
    args = function()
      local test_name = vim.fn.input "Test name: "
      return { "${file}::" .. test_name }
    end,
    pythonPath = resolve_python,
  },
}

-- DAP UI
local dapui_ok, dapui = pcall(require, "dapui")
if dapui_ok then
  dapui.setup()

  dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
  dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
  dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

  vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "DAP: Toggle UI" })
end

-- Keymaps
vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step Out" })
vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
vim.keymap.set(
  "n",
  "<Leader>dB",
  function() dap.set_breakpoint(vim.fn.input "Breakpoint condition: ") end,
  { desc = "DAP: Conditional Breakpoint" }
)
