local M = {}

function M.setup()
  -- Solo aplica keymaps en buffers de Rust
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
      local opts = { buffer = true, remap = false }

      -- LSP
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Documentación
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Ir a definición
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Acciones de código

      -- Ejecución
      vim.keymap.set("n", "<leader>cr", ":!cargo run<CR>", { desc = "Cargo Run" }) -- Ejecutar
      vim.keymap.set("n", "<leader>cb", ":!cargo build<CR>", { desc = "Cargo Build" }) -- Compilar
      vim.keymap.set("n", "<leader>ct", ":!cargo test<CR>", { desc = "Cargo Test" }) -- Tests

      -- Debugging
      -- vim.keymap.set("n", "<leader>dl", ':lua require("dap").step_into()<CR>', { desc = "Debugger step into" })
      -- vim.keymap.set("n", "<Leader>dj", ':lua require("dap").step_over()<CR>', { desc = "Debugger step over" })
      -- vim.keymap.set("n", "<Leader>dk", ':lua require("dap").step_out()<CR>', { desc = "Debugger step out" })
      -- vim.keymap.set("n", "<leader>dc", ':lua require("dap").continue()<CR>', { desc = "Debug Start" })
      -- vim.keymap.set("n", "<leader>db", ':lua require("dap").toggle_breakpoint()<CR>', { desc = "Toggle Breakpoint" })
      -- vim.keymap.set("n", "<leader>dr", ':lua require("dap").repl.open()<CR>', { desc = "Debug REPL" })
      -- vim.keymap.set("n", "<leader>du", ':lua require("dapui").toggle()<CR>', { desc = "Debug UI" })
      -- vim.keymap.set("n", "<leader>dl", ':lua require("dap").run_last()<CR>', { desc = "Debug Last" })
      -- vim.keymap.set("n", "<leader>de", ':lua require("dapui").eval()<CR>', { desc = "Debug Eval" })
      -- vim.keymap.set("n", "<leader>df", ':lua require("dap").run_to_cursor()<CR>', { desc = "Debug Run to Cursor" })
      -- vim.keymap.set("n", "<leader>ds", ':lua require("dap").stop()<CR>', { desc = "Debug Stop" })
      -- vim.keymap.set(
      --   "n",
      --   "<Leader>dd",
      --   ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
      --   { desc = "Debugger set conditional breakpoint" }
      -- )
      vim.keymap.set("n", "<F5>", function()
        require("dap").continue()
      end)
      vim.keymap.set("n", "<F6>", function()
        require("dap").run_to_cursor()
      end)
      vim.keymap.set("n", "<F7>", function()
        require("dap").run_last()
      end)
      vim.keymap.set("n", "<F8>", function()
        require("dap").step_over()
      end)
      vim.keymap.set("n", "<F10>", function()
        require("dap").repl.open()
      end)
      vim.keymap.set("n", "<F11>", function()
        require("dap").step_into()
      end)
      vim.keymap.set("n", "<F12>", function()
        require("dap").step_out()
      end)
      vim.keymap.set("n", "<leader>b", function()
        require("dap").toggle_breakpoint()
      end)
      vim.keymap.set("n", "<leader>B", function()
        require("dap").set_breakpoint(vim.fn.input("Condición: "))
      end)

      -- LSP and Refactor
      vim.keymap.set("n", "<leader>lr", ":RustLsp rename<CR>", { desc = "Rename Symbol" }) -- Renombrar
      vim.keymap.set("n", "<leader>lf", ":RustFmt<CR>", { desc = "Format File" }) -- Formatear

      -- Rust específico (comandos de rustaceanvim)
      vim.keymap.set("n", "<leader>rh", ":RustLsp hover actions<CR>", opts) -- Acciones flotantes
      vim.keymap.set("n", "<leader>rp", ":RustLsp parent module<CR>", opts) -- Ir al módulo padre
      vim.keymap.set("n", "<Leader>dt", ":RustLsp testables')<CR>", { desc = "Debugger testables" })
    end,
  })
end

return M
