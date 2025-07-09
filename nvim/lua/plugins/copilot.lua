return {
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
