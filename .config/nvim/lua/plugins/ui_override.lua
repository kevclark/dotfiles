return {
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
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    build = ":call mkdp#util#install()",
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
    version = false,
  },

}
