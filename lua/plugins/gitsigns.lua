return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    enabled = true,
    lazy = false,
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },

        signs_staged = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
        },

        -- 🔥 clave: blame tipo GitLens
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "right_align",
        },

        -- diff palabra por palabra
        word_diff = true,

        -- rendimiento
        max_file_length = 40000,

        preview_config = {
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },

        -- 🔥 KEYMAPS (esto viene del README)
        on_attach = function(bufnr)
          local gs = require("gitsigns")

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          -- navegación
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gs.nav_hunk("next")
            end
          end, "Next hunk")

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gs.nav_hunk("prev")
            end
          end, "Prev hunk")

          -- acciones
          map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
          map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
          map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
          map("n", "<leader>hb", gs.blame_line, "Blame line")

          -- visual mode
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, "Stage selection")

          -- toggle
          map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle blame")
          map("n", "<leader>td", gs.toggle_deleted, "Toggle deleted")
        end,
      })
    end,
  },
}
