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

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>fc",
        function()
          require("neo-tree.command").execute({ dir = os.getenv("HOME") .. "/.config/nvim" })
        end,
        desc = "Explorer NeoTree (config dir)",
      },
      {
        "<leader>fl",
        function()
          require("neo-tree.command").execute({ dir = os.getenv("HOME") .. "/.local/share/nvim/lazy/LazyVim" })
        end,
        desc = "Explorer NeoTree (LazyVim plug)",
      },
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
      -- add a keymap to preview available colorschemes in ui
      {
        "<leader>ut",
        function()
          require("telescope.builtin").colorscheme({ enable_preview = true })
        end,
        desc = "Themes - Colorschemes",
      },
      -- add a keymap to list buffers
      {
        "<leader>bl",
        function()
          require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({ previewer = false }))
        end,
        desc = "Buffer list",
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

  -- {
  --   "folke/noice.nvim",
  --   enabled = true,
  --   opts = {
  --     cmdline = {
  --       view = "cmdline_popup",
  --       -- view = "cmdline",
  --     },
  --     messages = {
  --       enabled = true,
  --     },
  --   },
  -- },
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local icons = require("lazyvim.config").icons

      local function fg(name)
        return function()
          ---@type {foreground?:number}?
          local hl = vim.api.nvim_get_hl_by_name(name, true)
          return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
        end
      end

      return {
        options = {
          theme = "gruvbox",
        },
        sections = {
          lualine_b = {
            { "branch", separator = "|", padding = { left = 1, right = 0 } },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_c = {
            { "filename", path = 1, symbols = { modified = "[+]", readonly = "[-]", unnamed = "" } },
                    -- stylua: ignore
                    {
                        function() return require("nvim-navic").get_location() end,
                        cond = function() return require("nvim-navic").is_available() end,
                    },
          },
          lualine_x = {
                    -- stylua: ignore
                    {
                        function() return require("noice").api.status.command.get() end,
                        cond = function() return require("noice").api.status.command.has() end,
                        color = fg("Statement")
                    },
                    -- stylua: ignore
                    {
                        function() return require("noice").api.status.mode.get() end,
                        cond = function() return require("noice").api.status.mode.has() end,
                        color = fg("Constant") ,
                    },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
          },
          lualine_y = { "filetype" },
          lualine_z = {
            { "progress", separator = "|", padding = { left = 1, right = 0 } },
            { "location", separator = "", padding = { left = 0, right = 1 } },
          },
        },
      }
    end,
  },
  -- disable alpha (the dashboad)
  { "goolord/alpha-nvim", enabled = false },
}
