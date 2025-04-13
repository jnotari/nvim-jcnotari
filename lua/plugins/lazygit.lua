return {
  "kdheepak/lazygit.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "LazyGit", -- Carga bajo demanda
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Abrir LazyGit" },
  },
  config = function()
    -- Opcional: Configuración personalizada de LazyGit
    vim.g.lazygit_floating_window_scaling_factor = 0.9 -- Tamaño de la ventana
  end,
}
