local dap = require "dap"
local ui = require "dapui"

ui.setup()
require("nvim-dap-virtual-text").setup()

dap.adapters.lldb = {
  type = "executable",
  command = "/nix/store/zkipgajv3yi83akcw8fwk0d0d64p09li-lldb-17.0.6/bin/lldb-vscode",
  name = "lldb",
}

dap.configurations.rust = {
  {
    name = "Rust debug",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd())
    end,
    -- exitAfterTaskReturns = false,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = function()
      local args = vim.fn.input("Enter command-line arguments: ")
      return vim.split(args, " ")
    end,

    -- "You can get rust types by adding:"
    -- The following is from https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
    initCommands = function()
      -- Find out where to look for the pretty printer Python module
      local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

      local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
      local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

      local commands = {}
      local file = io.open(commands_file, 'r')
      if file then
        for line in file:lines() do
          table.insert(commands, line)
        end
        file:close()
      end
      table.insert(commands, 1, script_import)

      return commands
    end,
  },
}

vim.keymap.set("n", "<space>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<space>dc", dap.run_to_cursor)
vim.keymap.set("n", "<space>dq", function()
  dap.terminate()
  ui.close()
end)
vim.keymap.set("n", "<space>d?", function()
  ui.eval(nil, { enter = true })
end)

vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_into)
vim.keymap.set("n", "<F3>", dap.step_over)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<F5>", dap.step_back)

dap.listeners.before.attach.dapui_config = function()
  ui.open()
end
dap.listeners.before.launch.dapui_config = function()
  ui.open()
end
