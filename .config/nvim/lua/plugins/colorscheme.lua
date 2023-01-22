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
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local gutter_fg = "#4B5263"
      -- local gutter_fg = "#3b4261"
      local dracula = require("dracula")
      dracula.setup({
        italic_comment = true,
        overrides = {
          -- Make floating window more visible aainst default background
          NormalFloat = { bg = "#2E303F" },
          -- Add hl for vim-illuminate
          illuminatedWord = { bg = gutter_fg },
          illuminatedCurWord = { bg = gutter_fg },
          IlluminatedWordText = { bg = gutter_fg },
          IlluminatedWordRead = { bg = gutter_fg },
          IlluminatedWordWrite = { bg = gutter_fg },
        },
      })

      -- the colorscheme will be set from lazyvim_override.lua
      -- local dracula = require("dracula")
      -- dracula.load()
    end,
  },
}
