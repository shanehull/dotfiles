-- Function to check if a module is available before requiring it.
local function safe_require(module)
	local ok, result = pcall(require, module)
	if ok and type(result) == "table" then
		return result
	end
end

-- Load the environment module safely (file can be absent).
local env = safe_require("env")

return {
	{
		"sourcegraph/sg.nvim",
		config = function()
			-- Run if enabled and not certain ft
			runFunc = function()
				if not vim.tbl_contains({ "markdown" }, vim.bo.ft) and env.ENABLE_CODY then
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
			if env.ENABLE_COPILOT then
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
