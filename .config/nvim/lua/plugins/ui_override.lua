return {
  -- toggleterm
  {
    "akinsho/toggleterm.nvim",
    version = false,
    opts = function()
      require("toggleterm").setup() 
    end,
  },
}
