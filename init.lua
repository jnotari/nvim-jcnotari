-- Configure Node.js before loading plugins
require("config.nodejs").setup({ silent = true })

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

vim.api.nvim_create_user_command("MeldCurrent", function()
  local filename = vim.fn.expand("%") -- Obtiene el nombre del archivo actual
  vim.fn.system("git mergetool -- " .. filename) -- Ejecuta git mergetool para ese archivo específico
  vim.cmd("checktime") -- Recarga el archivo para ver los cambios hechos por Meld
end, {})
