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
      wk.register({
        ["<leader>t"] = { name = "+terminal" },
        ["<leader>n"] = { name = "+Neorg" },
        ["gt"] = { name = "+Neorg Tasks" },
      })
    end,
  },

  {
    "nvim-neorg/neorg",
    cmd = "Neorg",
    build = ":Neorg sync-parsers",
    version = false,
    opts = {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.norg.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/.neorg/notes",
              work = "~/.neorg/work",
              homerprojects = "~/.neorg/homerprojects",
            },
            default_workspace = "homerprojects",
          },
        },
        ["core.keybinds"] = {
          config = {
            -- not remapping existing keybinds, only adding opts desc for which-key
            hook = function(keybinds)
             keybinds.unmap("norg", "n", "gtd")
             keybinds.map_event("norg", "n", "gtd", "core.norg.qol.todo_items.todo.task_done", { desc = "Task Done" })

             keybinds.unmap("norg", "n", "gtu")
             keybinds.map_event("norg", "n", "gtu", "core.norg.qol.todo_items.todo.task_undone", { desc = "Task Undone" })

             keybinds.unmap("norg", "n", "gtp")
             keybinds.map_event("norg", "n", "gtp", "core.norg.qol.todo_items.todo.task_pending", { desc = "Task Pending" })

             keybinds.unmap("norg", "n", "gth")
             keybinds.map_event("norg", "n", "gth", "core.norg.qol.todo_items.todo.task_on_hold", { desc = "Task On Hold" })

             keybinds.unmap("norg", "n", "gtc")
             keybinds.map_event("norg", "n", "gtc", "core.norg.qol.todo_items.todo.task_cancelled", { desc = "Task Cancelled" })

             keybinds.unmap("norg", "n", "gtr")
             keybinds.map_event("norg", "n", "gtr", "core.norg.qol.todo_items.todo.task_recurring", { desc = "Task Recurring" })

             keybinds.unmap("norg", "n", "gti")
             keybinds.map_event("norg", "n", "gti", "core.norg.qol.todo_items.todo.task_important", { desc = "Task Important" })

             keybinds.unmap("norg", "n", "<leader>nn")
             keybinds.map_event("norg", "n", "<leader>nn", "core.norg.dirman.new.note", { desc = "New Note" })
            end
          },
        },
      },
    },
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },

  {
    "iamcco/markdown-preview.nvim",
    build = ":call mkdp#util#install()",
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
    version = false,
  },

}
