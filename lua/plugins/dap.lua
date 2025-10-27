return {
  -- nvim-dap: Debug Adapter Protocol client
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- nvim-dap-ui: UI for nvim-dap
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dap, dapui = require("dap"), require("dapui")

          -- Setup dap-ui with default configuration
          dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            mappings = {
              expand = { "<CR>", "<2-LeftMouse>" },
              open = "o",
              remove = "d",
              edit = "e",
              repl = "r",
              toggle = "t",
            },
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.25 },
                  { id = "breakpoints", size = 0.25 },
                  { id = "stacks", size = 0.25 },
                  { id = "watches", size = 0.25 },
                },
                size = 40,
                position = "left",
              },
              {
                elements = {
                  { id = "repl", size = 0.5 },
                  { id = "console", size = 0.5 },
                },
                size = 10,
                position = "bottom",
              },
            },
            floating = {
              max_height = nil,
              max_width = nil,
              border = "single",
              mappings = {
                close = { "q", "<Esc>" },
              },
            },
          })

          -- Automatically open/close dap-ui
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      -- nvim-dap-python: Python extension for nvim-dap
      {
        "mfussenegger/nvim-dap-python",
        config = function()
          local path_sep = package.config:sub(1, 1)
          local is_windows = path_sep == "\\"
          local mason_path = vim.fn.stdpath("data") .. path_sep .. "mason"
          local debugpy_path = mason_path
            .. path_sep
            .. "packages"
            .. path_sep
            .. "debugpy"
            .. path_sep
            .. "venv"
            .. path_sep
            .. (is_windows and "Scripts" or "bin")
            .. path_sep
            .. (is_windows and "python.exe" or "python")

          require("dap-python").setup(debugpy_path)
        end,
      },
      -- nvim-dap-virtual-text: Show variable values as virtual text
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup({
            enabled = true,
            enabled_commands = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = false,
            show_stop_reason = true,
            commented = false,
            only_first_definition = true,
            all_references = false,
            display_callback = function(variable, buf, stackframe, node, options)
              if options.virt_text_pos == "inline" then
                return " = " .. variable.value
              else
                return variable.name .. " = " .. variable.value
              end
            end,
          })
        end,
      },
    },
    config = function()
      local dap = require("dap")
      local path_sep = package.config:sub(1, 1)
      local is_windows = path_sep == "\\"
      local mason_path = vim.fn.stdpath("data") .. path_sep .. "mason"

      -- Configure signs for breakpoints
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "", linehl = "", numhl = "" })

      -- Helper function to get Python path
      local function get_python_path()
        local cwd = vim.fn.getcwd()
        local executable_subdir = is_windows and "Scripts" or "bin"
        local python_exec = is_windows and "python.exe" or "python"

        -- Check for virtual environment
        if vim.fn.executable(cwd .. path_sep .. "venv" .. path_sep .. executable_subdir .. path_sep .. python_exec) == 1 then
          return cwd .. path_sep .. "venv" .. path_sep .. executable_subdir .. path_sep .. python_exec
        elseif vim.fn.executable(cwd .. path_sep .. ".venv" .. path_sep .. executable_subdir .. path_sep .. python_exec) == 1 then
          return cwd .. path_sep .. ".venv" .. path_sep .. executable_subdir .. path_sep .. python_exec
        else
          return python_exec
        end
      end

      -- Python adapter configuration
      dap.adapters.python = {
        type = "executable",
        command = mason_path
          .. path_sep
          .. "packages"
          .. path_sep
          .. "debugpy"
          .. path_sep
          .. "venv"
          .. path_sep
          .. (is_windows and "Scripts" or "bin")
          .. path_sep
          .. (is_windows and "python.exe" or "python"),
        args = { "-m", "debugpy.adapter" },
      }

      -- Python debug configurations
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = get_python_path,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "Launch file with arguments",
          program = "${file}",
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
          end,
          pythonPath = get_python_path,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "Run pytest",
          module = "pytest",
          args = { "${file}" },
          pythonPath = get_python_path,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "Run pytest (specific test)",
          module = "pytest",
          args = function()
            local test_name = vim.fn.input("Test name: ")
            return { "${file}::" .. test_name }
          end,
          pythonPath = get_python_path,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "Run pytest (all tests)",
          module = "pytest",
          args = {},
          pythonPath = get_python_path,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "Django",
          program = "${workspaceFolder}/manage.py",
          args = { "runserver", "--noreload" },
          pythonPath = get_python_path,
          django = true,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "Flask",
          module = "flask",
          env = {
            FLASK_APP = "${file}",
          },
          args = { "run", "--no-debugger", "--no-reload" },
          pythonPath = get_python_path,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "Run module",
          module = function()
            return vim.fn.input("Module name: ")
          end,
          pythonPath = get_python_path,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "attach",
          name = "Attach remote",
          connect = function()
            local host = vim.fn.input("Host [localhost]: ")
            host = host ~= "" and host or "localhost"
            local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
            return { host = host, port = port }
          end,
        },
      }
    end,
  },
}
