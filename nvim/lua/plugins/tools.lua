return {
	-- Nice UI for errors
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		config = function()
			require("trouble").setup({
				icons = false,
			})

			vim.keymap.set("n", "<leader>xx", function()
				require("trouble").toggle()
			end)
			vim.keymap.set("n", "<leader>xw", function()
				require("trouble").toggle("workspace_diagnostics")
			end)
			vim.keymap.set("n", "<leader>xd", function()
				require("trouble").toggle("document_diagnostics")
			end)
			vim.keymap.set("n", "<leader>xq", function()
				require("trouble").toggle("quickfix")
			end)
			vim.keymap.set("n", "<leader>xl", function()
				require("trouble").toggle("loclist")
			end)
			vim.keymap.set("n", "gR", function()
				require("trouble").toggle("lsp_references")
			end)
		end,
	},

	-- Undo history view
	{
		"mbbill/undotree",
		event = "VeryLazy",
		keys = { { "<leader>u", "UndotreeToggle", desc = "Toggle Undotree" } },
	},

	-- PrimeTime lethal weapon
	{
		"ThePrimeagen/harpoon",
		event = "VeryLazy",
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Add file to harpoon" })
			vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Open harpoon" })
		end,
	},

	-- Auto formatting and typing helpers
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{ "preservim/nerdcommenter", event = "VeryLazy" },
}
