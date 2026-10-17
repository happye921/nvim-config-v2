function ChangeColor(color)
  color = color or "everforest"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
end

return {
  --TOKYO NIGHT
  --    "folke/tokyonight.nvim",
  --    config = function()
  --        require("tokyonight").setup({
  --            -- your configuration comes here
  --            -- or leave it empty to use the default settings
  --            transparent = true, -- Enable this to disable setting the background color
  --            styles = {
  --                -- Style to be applied to different syntax groups
  --                -- Value is any valid attr-list value for `:help nvim_set_hl`
  --                comments = { italic = true },
  --                keywords = { italic = false },
  --            },
  --        })
  --
  --ROSE PINE
  --  "rose-pine/neovim",
  --  name = "rose-pine",
  --  config = function()
  --    ChangeColor()
  --  end

  --OXOCARBON
  --"nyoom-engineering/oxocarbon.nvim",
  --name = "oxocarbon"

  --EVERFOREST
  'sainnhe/everforest',
  name = "everforest",
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = "light"
    ChangeColor()
  end
}
