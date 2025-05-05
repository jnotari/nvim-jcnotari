local M = {}

function M.setup()
  -- Paths absolutos (ajusta según tu sistema)
  local rust_analyzer_path = vim.fn.expand("~/.cargo/bin/rust-analyzer")
  local rust_lldb_path = vim.fn.expand("/home/notari/.cargo/bin/rust-lldb")
  local rust_keymaps = require("config.rust-keymaps")
  local rust_dap = require("config.rust-dap")
  -- Configuración principal
  vim.g.rustaceanvim = {
    server = {
      cmd = { rust_analyzer_path },
      capabilities = {
        positionEncoding = "utf-8",
      },
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
            extraArgs = { "--no-deps" },
          },
          cargo = { allFeatures = true },
        },
      },
      files = {
        watcher = "client",
      },
    },
    dap = { -- Configuración DAP
      autoload_configurations = true,
      adapter = {
        type = "executable",
        command = rust_lldb_path,
        name = "rust_lldb",
      },
    },
    rust_keymaps.setup(), -- Configuración de keymaps
    rust_dap.setup(), -- Configuración de DAP
  }
end

return M
