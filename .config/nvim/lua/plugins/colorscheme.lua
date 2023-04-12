return {

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },

  -- onedark
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
  },

  -- rose-pine
  {
    "rose-pine/neovim",
    lazy = false,
    name = "rose-pine",
    priority = 1000,
    -- config = function()
    --   vim.cmd([[colorscheme rose-pine]])
    -- end,
  },

  {
    "shaunsingh/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
  },

  -- noctis
  {
    "talha-akram/noctis.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "maxmx03/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local dracula = require("dracula")

      dracula.setup({
        override = {
          -- make boolean values bold
          ['@boolean'] = { bold = true },
        },
      })
    end
  },
}
