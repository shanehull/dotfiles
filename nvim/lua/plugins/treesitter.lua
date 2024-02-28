return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "javascript",
                    "typescript",
                    "c",
                    "lua",
                    "go",
                    "terraform",
                    "vimdoc",
                    "yaml",
                    "make",
                    "nix",
                    "gitcommit",
                    "css",
                },
                ignore_install = {
                    "markdown",
                    "markdown_inline",
                },

                sync_install = false,

                auto_install = true,

                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },
}
