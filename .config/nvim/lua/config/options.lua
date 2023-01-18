-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local HOME = os.getenv("HOME")

local options = {
  backup = false, -- creates a backup file
  swapfile = false, -- dont create swap file
  cmdheight = 1,
  completeopt = { "menu", "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 3, -- Hide * markup for bold and italic
  fileencoding = "utf-8", -- the encoding written to a file
  hlsearch = true, -- highlight all matches on previous search pattern
  incsearch = true, -- Incremental search
  ignorecase = true, -- ignore case in search patterns
  --  mouse = "a",                             -- allow the mouse to be used in neovim
  pumblend = 10, -- Popup blend
  pumheight = 10, -- pop up menu height
  showcmd = true, -- Show (kal) command in status line.
  showmatch = true, -- Show matching brackets.
  showmode = false, -- Don't need this anymore as mode will appear in lualine
  showtabline = 2, -- always show tabs
  smartcase = true, -- smart case
  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
  updatetime = 300, -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 4, -- the number of spaces inserted for each indentation
  softtabstop = 4,
  tabstop = 4, -- insert 4 spaces for a tab
  formatoptions = "jcroqlnt", -- tcqj
  cursorline = true, -- highlight the current line
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth = 2, -- set number column width to 2 {default 4}
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = false, -- display lines as one long line
  scrolloff = 4, -- is one of my fav
  sidescrolloff = 4,
  guifont = "monospace:h17", -- the font used in graphical neovim applications
  spelllang = "en_gb",
  undodir = HOME .. "/.vim/undodir", -- undo file per file being edited
  undofile = true, -- undodir must exist
  colorcolumn = "100", -- file width column indicator
  wildmode = "longest:full,full", -- Command-line completion mode
}

local globals = {
  -- vim global options
  -- mapleader = " ",
  -- maplocalleader = " ",
  wildmenu = true,
  wildignore = "*.pyc,*_build/*,**/.git/*", -- ignore files
}

-- allows neovim to access the system clipboard
if vim.fn.has("unnamedplus") == 1 then
  vim.opt.clipboard:append("unnamedplus")
end

vim.opt.shortmess:append("c")
vim.opt.fillchars:append("diff:/")

vim.opt.list = true
vim.opt.listchars:append("tab:>-")
vim.opt.listchars:append("trail:~")
vim.opt.listchars:append("extends:>")
vim.opt.listchars:append("precedes:<")
vim.opt.listchars:append("lead:⋅")
vim.opt.listchars:append("multispace:⋅⋅⋅")
vim.opt.listchars:append("eol:↴")

for k, v in pairs(options) do
  vim.opt[k] = v
end

for k, v in pairs(globals) do
  vim.g[k] = v
end
