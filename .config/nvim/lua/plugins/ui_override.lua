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
      require("which-key").register({
        ["<leader>t"] = { name = "+terminal" },
      })
    end,
  },

}
