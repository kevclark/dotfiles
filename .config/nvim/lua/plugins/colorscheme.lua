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
      local dracula = require("dracula")
      local colors = require("dracula.palette")
      dracula.setup({
        italic_comment = true,
        overrides = {
          -- Match parenthesis in red
          MatchParen = { fg = colors.red, bold = true },
          -- Make floating window more visible aainst default background
          NormalFloat = { bg = "#2E303F" },
          -- Add hl for vim-illuminate
          illuminatedWord = { bg = colors.gutter_fg },
          illuminatedCurWord = { bg = colors.gutter_fg },
          IlluminatedWordText = { bg = colors.gutter_fg },
          IlluminatedWordRead = { bg = colors.gutter_fg },
          IlluminatedWordWrite = { bg = colors.gutter_fg },
        },
      })

      -- the colorscheme will be set from lazyvim_override.lua
      -- local dracula = require("dracula")
      -- dracula.load()
    end,
  },
}
