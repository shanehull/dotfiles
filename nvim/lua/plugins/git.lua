return {
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

            local TheShed_Fugitive = vim.api.nvim_create_augroup("TheShed_Fugitive", {})

            local autocmd = vim.api.nvim_create_autocmd
            autocmd("BufWinEnter", {
                group = TheShed_Fugitive,
                pattern = "*",
                callback = function()
                    if vim.bo.ft ~= "fugitive" then
                        return
                    end

                    local bufnr = vim.api.nvim_get_current_buf()

                    local opts = { buffer = bufnr, remap = false }

                    vim.keymap.set("n", "<leader>p", function()
                        vim.cmd.Git("push")
                    end, opts)

                    vim.keymap.set("n", "<leader>P", function()
                        vim.cmd.Git({ "pull", "--rebase" })
                    end, opts)
                end,
            })
        end,
    },

    {
        "kdheepak/lazygit.nvim",
        enabled = false,
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            vim.keymap.set("n", "<leader>gg", vim.cmd.LazyGit)
        end,
    },
}
