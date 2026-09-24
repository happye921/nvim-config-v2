return {
  "folke/snacks.nvim",

  opts = {
    terminal = {
      enabled = true,
    },
  },

  config = function(_, opts)
    local Snacks = require("snacks")
    Snacks.setup(opts)

    local codex_opts = {
      cwd = vim.fn.getcwd(),

      win = {
        position = "right",
        width = 0.4,

        wo = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
        },
      },
    }

    local function toggle_codex()
      Snacks.terminal.toggle("codex", codex_opts)
    end

    -- Open or hide Codex from normal files.
    vim.keymap.set("n", "<leader>cc", toggle_codex, {
      silent = true,
      desc = "Toggle Codex",
    })

    -- Close Codex directly while typing inside the terminal.
    vim.keymap.set("t", "<C-q>", function()
      toggle_codex()
    end, {
      silent = true,
      nowait = true,
      desc = "Close Codex",
    })
  end,
}
