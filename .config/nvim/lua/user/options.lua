local HOME = os.getenv("HOME")

local options = {
  backup = false,                          -- creates a backup file
  swapfile = false,                        -- dont create swap file
  -- cmdheight = 2,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  incsearch = true,                        -- Incremental search
  ignorecase = true,                       -- ignore case in search patterns
--  mouse = "a",                             -- allow the mouse to be used in neovim
  pumheight = 10,                          -- pop up menu height
  showcmd = true,                          -- Show (partial) command in status line.
  showmatch = true,                        -- Show matching brackets.
  showmode = false,                         -- Don't need this anymore as mode will appear in lualine
  showtabline = 2,                         -- always show tabs
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 100,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  updatetime = 300,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 4 spaces for a tab
  cursorline = true,                       -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = true,                   -- set relative numbered lines
  numberwidth = 2,                         -- set number column width to 2 {default 4}
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = false,                            -- display lines as one long line
  scrolloff = 4,                           -- is one of my fav
  sidescrolloff = 4,
  guifont = "monospace:h17",               -- the font used in graphical neovim applications
  spelllang = "en_gb",
  undodir = HOME .. "/.vim/undodir",       -- undo file per file being edited
  undofile = true,                         -- undodir must exist
  colorcolumn = "100",                     -- file width column indicator
}

local globals = {
    -- vim global options
    -- wildmenu = true,
    -- wildignore = "*.pyc",                       -- ignore files
    -- wildignore = wildignore .. ",*_build/*",
    -- wildignore = wildignore .. ",**/.git/*",
}

-- allows neovim to access the system clipboard
if vim.fn.has('unnamedplus') == 1 then
    vim.opt.clipboard:append 'unnamedplus'
end

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end

for k, v in pairs(globals) do
  vim.g[k] = v
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work
