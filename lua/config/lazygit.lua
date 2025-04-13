local M = {}

M.setup = function()
  vim.g.lazygit_config = {
    floating_window = {
      border = "rounded", -- Borde estético
      winblend = 10, -- Transparencia
    },
    settings = {
      git_editor = "nvim", -- Usa Neovim para mensajes de commit
    },
  }
end

return M
