return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")
    local path_sep = package.config:sub(1, 1) -- Determine OS path separator
    local is_windows = path_sep == "\\"
    local mason_path = vim.fn.stdpath("data") .. path_sep .. "mason"

    -- Adapter configuration
    dap.adapters.python = {
      type = "executable",
      command = mason_path ..
        path_sep ..
        "packages" ..
        path_sep ..
        "debugpy" ..
        path_sep ..
        "venv" ..
        path_sep ..
        (is_windows and "Scripts" or "bin") ..
        path_sep ..
        (is_windows and "python.exe" or "python"),
      args = { "-m", "debugpy.adapter" },
    }

    -- Configuration for debugging
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          local executable_subdir = is_windows and "Scripts" or "bin"
          local python_exec = is_windows and "python.exe" or "python"

          if vim.fn.executable(cwd .. path_sep .. "venv" .. path_sep .. executable_subdir .. path_sep .. python_exec) == 1 then
            return cwd .. path_sep .. "venv" .. path_sep .. executable_subdir .. path_sep .. python_exec
          elseif vim.fn.executable(cwd .. path_sep .. ".venv" .. path_sep .. executable_subdir .. path_sep .. python_exec) == 1 then
            return cwd .. path_sep .. ".venv" .. path_sep .. executable_subdir .. path_sep .. python_exec
          else
            return python_exec
          end
        end,
      },
      {
        type = "python",
        request = "launch",
        name = "Run pytest",
        module = "pytest",
        args = { "${file}" },
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          local executable_subdir = is_windows and "Scripts" or "bin"
          local python_exec = is_windows and "python.exe" or "python"

          if vim.fn.executable(cwd .. path_sep .. "venv" .. path_sep .. executable_subdir .. path_sep .. python_exec) == 1 then
            return cwd .. path_sep .. "venv" .. path_sep .. executable_subdir .. path_sep .. python_exec
          elseif vim.fn.executable(cwd .. path_sep .. ".venv" .. path_sep .. executable_subdir .. path_sep .. python_exec) == 1 then
            return cwd .. path_sep .. ".venv" .. path_sep .. executable_subdir .. path_sep .. python_exec
          else
            return python_exec
          end
        end,
      },
      {
        type = "python",
        request = "launch",
        name = "Run pytest (test case)",
        module = "pytest",
        args = function()
          local test_name = vim.fn.input("Test name: ")
          return { "${file}::" .. test_name }
        end,
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          local executable_subdir = is_windows and "Scripts" or "bin"
          local python_exec = is_windows and "python.exe" or "python"

          if vim.fn.executable(cwd .. path_sep .. "venv" .. path_sep .. executable_subdir .. path_sep .. python_exec) == 1 then
            return cwd .. path_sep .. "venv" .. path_sep .. executable_subdir .. path_sep .. python_exec
          elseif vim.fn.executable(cwd .. path_sep .. ".venv" .. path_sep .. executable_subdir .. path_sep .. python_exec) == 1 then
            return cwd .. path_sep .. ".venv" .. path_sep .. executable_subdir .. path_sep .. python_exec
          else
            return python_exec
          end
        end,
      },
    }
  end,
}
