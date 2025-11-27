vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move cursor and screen down 1/2 page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move cursor and screen up 1/2 page" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d', { desc = "Delete (cut) to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<leader>yy", '"+yy', { desc = "Copy until end of line to system clipboard" })
vim.keymap.set("n", "<leader>dd", '"+dd', { desc = "Delete (cut) until end of line to system clipboard" })

vim.keymap.set("n", "<leader>ge", "iif err != nil {\n// TODO: handle me\n}", { desc = "Paste a Go error != nil block" })

vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "LSP: Go to Definition" })
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = "LSP: Go to Type Definition" })
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "LSP: Go to Implementation" })
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "LSP: Show Documentation" })
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "LSP: Find References" })
vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "LSP: Code Action" })
vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "LSP: Rename Symbol" })
