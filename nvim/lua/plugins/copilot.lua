return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		cond = function()
			return vim.env.ENABLE_COPILOT ~= nil and vim.env.ENABLE_COPILOT ~= ""
		end,
		config = function()
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
		end,
	},
}
