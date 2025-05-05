local M = {}

function M.setup()
  local dap = require("dap")

  -- 1. Adaptador para codelldb
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = "codelldb",
      args = { "--port", "${port}", "--settings", '{"showDisassembly":"auto"}' },
    },
    options = {
      initialize_timeout_sec = 30,
    },
  }

  -- 2. Configuración para proyectos Rust
  dap.configurations.rust = {
    {
      name = "Launch Rust (codelldb)",
      type = "codelldb", -- ¡Debe coincidir con el nombre del adaptador!
      request = "launch",
      program = function()
        -- Autodetecta el binario debug o pide ruta
        local default_path = vim.fn.getcwd() .. "/target/debug/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        if vim.fn.filereadable(default_path) == 1 then
          return default_path
        end
        return vim.fn.input("Path to executable: ", default_path, "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
      env = {
        RUST_BACKTRACE = "full",
      },
      -- Opciones avanzadas
      sourceLanguages = { "rust" },
      terminal = "integrated",
      showDisassembly = "auto", -- Muestra ensamblado si hay errores
    },
  }
end

return M
