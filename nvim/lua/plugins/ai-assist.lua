return {
	{
		"sourcegraph/sg.nvim",
		config = function()
			-- Function to check if a module is available before requiring it.
			local function safe_require(module)
				local ok, result = pcall(require, module)
				if ok and type(result) == "table" then
					return result
				else
					return { ALLOW_AI_ASSIST = false }
				end
			end

			-- Load the environment module safely (file can be absent).
			local env = safe_require("env")

			-- Enable cody?
			local enable_cody = env.ALLOW_AI_ASSIST

			-- Run if enabled and not certain ft
			runFunc = function()
				if not vim.tbl_contains({ "markdown" }, vim.bo.ft) and enable_cody then
					require("sg").setup({})
				end
			end
			vim.defer_fn(runFunc, 50)
		end,
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	},
}
