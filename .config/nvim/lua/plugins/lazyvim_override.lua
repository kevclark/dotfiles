-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins

return {
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
      -- add a keymap to preview available colorschemes
      {
        "<leader>cs",
        function()
          require("telescope.builtin").colorscheme({ enable_preview = true })
        end,
        desc = "Colorschemes",
      },
    },
    -- change some options
    -- opts = {
    --   defaults = {
    --     layout_strategy = "horizontal",
    --     layout_config = { prompt_position = "top" },
    --     sorting_strategy = "ascending",
    --     winblend = 0,
    --   },
    -- },
  },

  -- add other languages to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- lsp servers will be automatically installed with mason and loaded with lspconfig
        pyright = {},
        clangd = {},
        bashls = {},
        yamlls = {},
      },
    },
  },

  -- disable alpha (the dashboad)
  { "goolord/alpha-nvim", enabled = false },
}
