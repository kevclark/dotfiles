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
      { "<leader>fF", LazyVim.pick("auto", { cwd = nil }), desc = "Find Files (cwd)" },
      { "<leader>fG", LazyVim.pick("auto", { cwd = nil, use_git_root = false }), desc = "Git Files (cwd)" },
    },
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
      -- autoformat = false,
      servers = {
        -- lsp servers will be automatically installed with mason and loaded with lspconfig
        -- mason = false, -- set to false if you don't want this server to be installed with mason
        pyright = {},
        clangd = {},
        bashls = {},
        lua_ls = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
        yaml = { "yamlfmt" },
        c = { "uncrustify" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        cmake = { "cmakelint" },
        python = { "pylint", "mypy" },
        yaml = { "yamllint" },
      },
    },
  },

  {
    "folke/which-key.nvim",
      opts = {
        preset = "modern"
      },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame_opts = {
        delay = 200,
      },
    },
    keys = {
      -- Toggle current line git blame
      { "<leader>ghl", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle line blame" },
    },
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",

      "ibhagwan/fzf-lua",
    },
    cmd = "Neogit",
    config = function()
      require("neogit").setup({
        -- "ascii"   is the graph the git CLI generates
        -- "unicode" is the graph like https://github.com/rbong/vim-flog
        graph_style = "unicode",
        -- Used to generate URL's for branch popup action "pull request".
        -- git_services = {
        --   ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
        -- }
        -- Disable line numbers and relative line numbers
        disable_line_numbers = false,
      })
    end,
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
  },

  {
    "FabijanZulj/blame.nvim",
    cmd = "BlameToggle",
    config = function()
      require("blame").setup()
    end,
    keys = {
      { "<leader>gB", "<cmd>BlameToggle<cr>", desc = "Git Blame File" },
    },
  },


  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "vimdoc",
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

  -- Add project.nvim
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension("projects")
      require("project_nvim").setup({
        -- stop changing cwd when entering a buffer
        manual_mode = true,
        silent_chdir = false,
      })
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

  -- another session manager
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

  -- add symbol navigation
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    version = false,
    opts = function()
      require("symbols-outline").setup()
    end,
    keys = {
      {
        "<leader>cs",
        "<cmd>SymbolsOutline<cr>",
        desc = "Symbols",
      },
    },
  },

  -- diffview
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewToggleFiles", "DiffviewFileHistory" },
    config = function()
      require("diffview").setup({
        merge_tool = {
          -- Config for conflicted files in diff views during a merge or rebase.
          layout = "diff4_mixed",
        },
      })
    end,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
    },
  },


  -- change blink config
  {
    "saghen/blink.cmp",
    -- opts will be merged with the parent spec
    opts = { 
      completion = {
        menu = {
          auto_show = false,
        },
      },
      keymap = {
        preset = "none",
        ['<C-i>'] = { 'show' },
        ['<C-e>'] = { 'hide' },
        ['<C-y>'] = { 'select_and_accept' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },
    },
  },

  -- vim-tmux-navigator
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
  },

  -- disable dashboards!
  { "folke/snacks.nvim", opts = { dashboard = { enabled = false } } },
  { "nvimdev/dashboard-nvim", enabled = false },
}
