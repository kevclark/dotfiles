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
  
  { "shaunsingh/oxocarbon.nvim" },

  { "ellisonleao/gruvbox.nvim" },

  { 
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- local dracula = require("dracula")
      -- dracula.setup({ transparent_bg = true, })
      local dracula = require("dracula")
      dracula.load()
    end,
  },
}
