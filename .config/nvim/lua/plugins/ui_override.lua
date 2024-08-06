return {
  -- which-key
  {
    "folke/which-key.nvim",
    opts = function()
      local wk = require("which-key")
      wk.setup()
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    build = ":call mkdp#util#install()",
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
    version = false,
  },

}
