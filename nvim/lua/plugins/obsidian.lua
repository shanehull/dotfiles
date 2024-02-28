return {
	"epwalsh/obsidian.nvim",
	version = "*", -- use latest release instead of latest commit
	lazy = true,
	--ft = { "markdown" },
	event = {
		"BufReadPre " .. vim.fn.expand("~") .. "/secondbrain/**/**.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/secondbrain/**/**.md",
		--"BufReadPre " .. vim.fn.expand("$SECOND_BRAIN") .. "/**/**.md",
		--"BufNewFile " .. vim.fn.expand("$SECOND_BRAIN") .. "/**/**.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "secondbrain",
				path = "~/secondbrain",
			},
		},
	},
	config = function()
		vim.opt.conceallevel = 2
		require("obsidian").setup({
			workspaces = {
				{
					name = "secondbrain",
					path = "~/secondbrain",
				},
			},
		})
	end,
}
