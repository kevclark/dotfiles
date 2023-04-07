-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Shorten function name and set default options
-- local keymap = vim.keymap.set
local function keymap(mode, lhs, rhs, opt)
  local opts = vim.tbl_deep_extend("force", { noremap = true, silent = true }, opt or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Remove some keymaps from LazyVim and revert binding to vim defaults
-- These where mapped to Prev and Next buffer - prefer the old vim bindings of jumping to top and botton of buffer
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

-- Remove the defaut keymaps for the LazyVim terminal shortcuts
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")

-- Better window navigation
keymap("n", "<C-Up>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-Down>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-Left>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-Right>", "<C-w>l", { desc = "Go to right window" })

-- Window nav in and out of terminals
keymap("t", "<esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
keymap("t", "<C-Up>", [[<Cmd>wincmd k<CR>]], { desc = "Go to upper window" })
keymap("t", "<C-Down>", [[<Cmd>wincmd j<CR>]], { desc = "Go to lower window" })
keymap("t", "<C-Left>", [[<Cmd>wincmd h<CR>]], { desc = "Go to left window" })
keymap("t", "<C-Right>", [[<Cmd>wincmd l<CR>]], { desc = "Go to right window" })

-- Resize with arrows
keymap("n", "<S-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<S-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<S-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<S-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Navigate buffers
keymap("n", "<A-Right>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<A-Left>", ":bprevious<CR>", { desc = "Prev buffer" })

-- Press jk fast to enter
keymap("i", "jk", "<ESC>")
-- for colemak
keymap("i", "fg", "<ESC>")

-- Stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move down" })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move down" })
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move down" })
keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move up" })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move up" })
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move up" })

-- Clear search with <esc>
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Better register control (more in whichkey.lua)
keymap("v", "p", '"_dP', { desc = "Send to the black hole before pasting" })
keymap("v", ",d", '"_d', { desc = "Send to the black hole instead moving to register" })

-- Should system clipboard only copied to via the leader?
-- keymap({"n", "v"}, "<leader>y", [["+y]])
-- keymap("n", "<leader>Y", [["+Y]])

-- Centre screen when jumping and searching for next match
keymap("n", "J", "mzJ`z")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- windows
keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
keymap("n", "<leader>wh", "<C-W>s", { desc = "Horizontal split below" })
keymap("n", "<leader>wv", "<C-W>v", { desc = "Veritcal split right" })

-- Delete buffer without removing window / split
keymap("n", "<leader>d", ":bp<bar>sp<bar>bn<bar>bd<CR>", { desc = "Delete Buffer, keep window/split" })

-- save in insert mode
-- (may want to go gack to the old <leader>w method - try it for a while)
keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Help on keyword where curson is
keymap({ "i", "n" }, "<A-h>", ':h <C-R>=expand("<cword>")<cr><cr>', { desc = "Help on cursor" })

-- quit
keymap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
