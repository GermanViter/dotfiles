vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")

-- use control hjkl to move current line up and down
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==")
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==")
vim.keymap.set("i", "jj", "<Esc>")

-- netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--increment/decrement
vim.keymap.set("n", "<leader>i", "<C-a>")
vim.keymap.set("n", "<leader>d", "<C-x>")

-- undo tree toggle
vim.keymap.set("n", "<leader>U", ":UndotreeToggle<CR>")

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
