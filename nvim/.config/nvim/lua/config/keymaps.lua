vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- use control hjkl to move current line up and down
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==")
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==")
vim.keymap.set("i", "jj", "<Esc>")

-- undo tree toggle
vim.keymap.set("n", "<leader>U", ":UndotreeToggle<CR>")
