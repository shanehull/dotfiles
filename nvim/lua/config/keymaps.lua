vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move cursor and screen down 1/2 page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move cursor and screen up 1/2 page" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d', { desc = "Delete (cut) to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<leader>yy", '"+yy', { desc = "Copy until end of line to system clipboard" })
vim.keymap.set("n", "<leader>dd", '"+dd', { desc = "Delete (cut) until end of line to system clipboard" })

vim.keymap.set("n", "<leader>ge", "iif err != nil {\n// TODO: handle me\n}", { desc = "Paste a Go error != nil block" })
