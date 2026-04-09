return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"javascript",
				"typescript",
				"c",
				"lua",
				"go",
				"terraform",
				"vim",
				"vimdoc",
				"yaml",
				"make",
				"nix",
				"gitcommit",
				"css",
				"regex",
				"markdown",
				"markdown_inline",
			},
			highlight = { enable = true },
			indent = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)
		end,
	},
}
