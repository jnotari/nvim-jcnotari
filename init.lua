-- Configure Node.js before loading plugins
require("config.nodejs").setup({ silent = true })

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

-- Cargar tu configuración personalizada de YAML
require("config.yaml") -- Ajusta la ruta según tu estructura
