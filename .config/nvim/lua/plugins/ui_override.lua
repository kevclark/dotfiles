return {
  -- toggleterm
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    version = false,
    opts = function()
      require("toggleterm").setup() 
    end,
    keys = {
      {
        "<leader>tf",
        "<cmd>ToggleTerm direction=float<cr>",
        desc = "Terminal (float)",
      },
      {
        "<leader>tt",
        "<cmd>ToggleTerm size=15 direction=horizontal<cr>",
        desc = "Terminal (horizontal)",
      },
      {
        "<leader>tv",
        "<cmd>ToggleTerm size=80 direction=vertical<cr>",
        desc = "Terminal (vertical)",
      },
    },
  },

  -- which-key
  {
    "folke/which-key.nvim",
    opts = function()
      local wk = require("which-key")
      wk.setup({
        triggers_blacklist = {
          -- WhichKey already blacklists j and k in insert mode, which is why the
          -- common mapping jk, used to quickly enter normal mode, does not bring
          -- up the WhichKey menu. However fg is used from insert mode to enter
          -- normal mode when using colemak rather than querty keyboard layout.
          i = { "f" },
        },
      })
      wk.register({
        ["<leader>t"] = { name = "+terminal" },
      })
    end,
  },

  {
    "nvim-neorg/neorg",
    cmd = "Neorg",
    build = ":Neorg sync-parsers",
    opts = {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.norg.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/.neorg/notes",
              work = "~/.neorg/work",
              homerprojects = "~/.neorg/homerprojects",
            },
          },
        },
      },
    },
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },

}
