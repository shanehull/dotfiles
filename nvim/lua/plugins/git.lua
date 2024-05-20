return {
    {
        "NeogitOrg/neogit",
        tag = "v1.0.0",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("neogit").setup({})

            vim.keymap.set("n", "<leader>gs", vim.cmd.Neogit, { desc = "Toggle neogit" })

            vim.keymap.set("n", "<leader>p", ":Neogit push<CR>", { desc = "Push to origin" })

            vim.keymap.set("n", "<leader>P", ":!git pull -r<CR>", { desc = "Pull from origin (rebase)" })
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        config = true,
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            current_line_blame = true,
        },
    },
}
