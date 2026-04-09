return {
	"obsidian-nvim/obsidian.nvim",
	version = "3",
	lazy = true,
	event = {
		"BufReadPre " .. vim.fn.expand("$SECOND_BRAIN") .. "/**/**.md",
		"BufNewFile " .. vim.fn.expand("$SECOND_BRAIN") .. "/**/**.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		legacy_commands = false,
		workspaces = {
			{
				name = "secondbrain",
				path = "~/secondbrain",
			},
		},
		attachments = {
			folder = "assets/imgs",
		},
	},
	init = function()
		vim.opt_local.conceallevel = 2
	end,
}