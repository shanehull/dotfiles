return {
	{
		"sourcegraph/sg.nvim",
		build = "nvim -l build/init.lua",
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

			if enable_cody then
				require("sg").setup({})
			end
		end,
	},
}
