return {

  -- onedark
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
  },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local tokyonight = require("tokyonight")
      tokyonight.setup({ style = "moon" })
      -- tokyonight.load()
    end,
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
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
  { "shaunsingh/oxocarbon.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { 
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- local dracula = require("dracula")
      -- dracula.setup({ transparent_bg = true, })
      vim.cmd([[colorscheme dracula]])
    end,
  },
}

