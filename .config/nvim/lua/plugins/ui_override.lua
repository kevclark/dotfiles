return {
  {
    "iamcco/markdown-preview.nvim",
    build = ":call mkdp#util#install()",
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
    version = false,
  },
  {
      "OXY2DEV/markview.nvim",
      lazy = false
  },
}
