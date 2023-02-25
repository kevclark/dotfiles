-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins

local Util = require("lazyvim.util")

return {
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    -- use latest dev version of LazyVim
    version = false,
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
      -- override default LazyVim find files maps
      { "<leader>ff", Util.telescope("find_files"), desc = "Find files (root dir)" },
      { "<leader>fF", Util.telescope("find_files", { cwd = false }), desc = "Find Files (cwd)" },
      { "<leader>fg", Util.telescope("git_files"), desc = "Git files (root dir)" },
      { "<leader>fG", Util.telescope("git_files", { cwd = false, use_git_root = false }), desc = "Git Files (cwd)" },
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
      -- Disable autoformat on save that LazyVim enables
      -- don't want this on legacy projects that are using a different
      -- formatter tool
      autoformat = false,
      servers = {
        -- lsp servers will be automatically installed with mason and loaded with lspconfig
        pyright = {},
        clangd = {},
        bashls = {},
        yamlls = {},
      },
    },
  },

  -- Cannot add to LazyVim null-ls spec, so is repaced here
  -- add more linters / formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.flake8,
          nls.builtins.formatting.black,
          nls.builtins.diagnostics.yamllint,
          nls.builtins.formatting.yamlfmt,
        },
      }
    end,
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
          theme = "tokyonight",
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
              color = fg("Constant"),
            },
            -- stylua: ignore
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
    "akinsho/bufferline.nvim",
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

  -- Add project.nvim
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
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

  -- another sessino manager
  {
    "gennaro-tedesco/nvim-possession",
    dependencies = {
      "ibhagwan/fzf-lua",
    },
    config = true,
    keys = {
      -- add a keymap to view sessions
      -- stylua: ignore
      {
        "<leader>qv",
        function() require("nvim-possession").list() end,
        desc = "View Sessions",
      },
      -- add a keymap to add a session
      -- stylua: ignore
      {
        "<leader>qn",
        function() require("nvim-possession").new() end,
        desc = "Add Session",
      },
      -- add a keymap to update a session
      -- stylua: ignore
      {
        "<leader>qu",
        function() require("nvim-possession").update() end,
        desc = "Update Session",
      },
    },
  },
  -- disable alpha (the dashboad)
  { "goolord/alpha-nvim", enabled = false },
}
