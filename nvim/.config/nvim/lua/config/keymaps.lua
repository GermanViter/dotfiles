-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- use control hjkl to move current line up and down
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==")
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==")
vim.keymap.set("i", "jj", "<Esc>")
