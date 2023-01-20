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
      diagnostics = {
        virtual_text = false, -- disable inline diagnostics
      },
      servers = {
        -- lsp servers will be automatically installed with mason and loaded with lspconfig
        pyright = {},
        clangd = {},
        bashls = {},
        yamlls = {},
      },
    },
  },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "help",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "c",
        "cmake",
        "go",
        "make",
        "rust",
        "toml",
      },
    },
  },

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
            { "location", separator = "|", padding = { left = 1, right = 0 } },
            { "progress", separator = "", padding = { left = 0, right = 1 } },
          },
        },
      }
    end,
  },

  -- bufferline
  {
    "akinsho/nvim-bufferline.lua",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      show_trailing_blankline_indent = true,
      show_current_context = true,
    },
  },

  -- LazyVim bindings were getting hdden by python lsp function jumbs
  -- appears to be broken for lua files
  {
    "RRethy/vim-illuminate",
    -- stylua: ignore
    keys = {
      { "}}", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference", },
      { "{{", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference" },
    },
  },

  -- Add project.nvim
  {
    "ahmedkhalf/project.nvim",
    cmd = "ProjectRoot",
    -- need to find a suitable event to load this plugin rather that from boot
    lazy = false,
    config = function()
      require("telescope").load_extension("projects")
      require("project_nvim").setup({})
    end,
    keys = {
      -- add a keymap to browse projects
      -- stylua: ignore
      {
        "<leader>sp",
        function() require("telescope").extensions.projects.projects() end,
        desc = "Projects",
      },
    },
  },

  -- disable alpha (the dashboad)
  { "goolord/alpha-nvim", enabled = false },
}
