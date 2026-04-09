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
			-- The 'main' branch of nvim-treesitter is a complete rewrite.
			-- It no longer uses nvim-treesitter.configs.
			-- If you need to manually install things, use :TSUpdate
		end,
	},
}
