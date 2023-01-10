return {

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

  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    -- config = function()
    -- local dracula = require("dracula")
    -- dracula.setup({ transparent_bg = true, })

    -- the colorscheme will be set from lazyvim_override.lua
    -- local dracula = require("dracula")
    -- dracula.load()
    -- end,
  },
}
