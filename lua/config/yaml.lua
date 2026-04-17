local function check_yml_paths()
  -- 1. Solo para archivos YAML
  local extension = vim.fn.expand("%:e")
  if not (extension == "yml" or extension == "yaml") then
    return
  end

  -- 2. Limpiar diagnósticos anteriores de ESTE validador
  local ns = vim.api.nvim_create_namespace("yaml_path_validator")
  vim.diagnostic.reset(ns, 0) -- Limpia solo nuestros diagnósticos

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local diagnostics = {}
  local pattern = ":%s*['\"]?([/~%w%._%-%/%+]+)['\"]?"

  local ignore_patterns = {
    "^[A-Z][a-z]+/[A-Z][a-z]+$", -- Zonas horarias: America/Santiago, Europe/Madrid
    "^%d%d%d%d%-%d%d%-%d%d", -- Fechas: 2023-12-31
    "^%d+%.%d+%.%d+", -- Versiones: 1.2.3, 2024.01.15
    "^[%a%.%-]+@[%a%.%-]+", -- Emails: user@domain.com
    "^%x%x%x%x%x%x%x%x%-", -- UUIDs parciales
  }

  -- 3. Buscar rutas y crear diagnósticos
  for i, line in ipairs(lines) do
    for path in line:gmatch(pattern) do
      local should_ignore = false
      for _, ignore_pattern in ipairs(ignore_patterns) do
        if path:match(ignore_pattern) then
          should_ignore = true
        end
      end
      if path:match("/") and not path:match("^%a+://") and not path:match("^git@") and not should_ignore then
        local full_path = path

        -- Convertir ruta relativa a absoluta
        if path:match("^%.%./") or path:match("^%.%/") then
          local current_dir = vim.fn.expand("%:p:h")
          full_path = vim.fn.resolve(current_dir .. "/" .. path)
        elseif not path:match("^/") then
          local current_dir = vim.fn.expand("%:p:h")
          full_path = vim.fn.resolve(current_dir .. "/" .. path)
        end

        -- Verificar si el archivo NO existe
        if vim.fn.filereadable(full_path) == 0 then
          -- Calcular la columna donde empieza la ruta
          local col_start = line:find(path, 1, true) or 0

          -- Crear diagnóstico (similar a LSP)
          table.insert(diagnostics, {
            lnum = i - 1, -- Línea (0-based en API)
            col = col_start - 1, -- Columna (0-based)
            end_lnum = i - 1,
            end_col = col_start - 1 + #path,
            severity = vim.diagnostic.severity.ERROR,
            message = "Ruta no encontrada: " .. path,
            source = "YAML Path Validator",
          })
        end
      end
    end
  end

  -- 4. Mostrar diagnósticos en el buffer (subrayados)
  if #diagnostics > 0 then
    vim.diagnostic.set(ns, 0, diagnostics)

    -- 5. Abrir automáticamente la location list con los errores
    vim.cmd("lopen") -- Abre la ventana de ubicaciones

    -- Opcional: Configurar signos en la columna de signos
    vim.fn.sign_define("YamlPathError", {
      text = "✗",
      texthl = "DiagnosticError",
      linehl = "",
      numhl = "DiagnosticError",
    })
  else
    -- No hay errores: cerrar location list si estaba abierta por nosotros
    vim.diagnostic.reset(ns, 0)
  end
end

-- Crear el autocomando que se ejecuta al guardar archivos .yml/.yaml
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.yml,*.yaml",
  callback = check_yml_paths,
  desc = "Validar rutas en archivos YAML después de guardar",
})
