return {
	{
		"sourcegraph/sg.nvim",
		config = function()
			-- Run if enabled and not certain ft
			runFunc = function()
				if not vim.tbl_contains({ "markdown" }, vim.bo.ft) and vim.env.ENABLE_CODY == "true" then
					require("sg").setup({})
				end
			end
			vim.defer_fn(runFunc, 50)
		end,
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			if vim.env.ENABLE_COPILOT == "true" then
				require("copilot").setup({
					suggestion = {
						enabled = false,
					},
					panel = {
						enabled = false,
					},
					filetypes = {
						yaml = true,
					},
				})
			end
		end,
	},
}
