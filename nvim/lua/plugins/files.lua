return {
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { { "nvim-lua/plenary.nvim" } },
		config = function()
			require("telescope").setup({
				pickers = {
					find_files = {
						hidden = true,
					},
					grep_string = {
						additional_args = { "--hidden" },
					},
					live_grep = {
						additional_args = { "--hidden" },
						file_ignore_patterns = {
							"yarn%.lock",
							"node_modules/",
							"raycast/",
							"dist/",
							"%.next",
							"%.git/",
							"%.gitlab/",
							"build/",
							"target/",
							"package%-lock%.json",
						},
					},
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find a file with telescope" })
			vim.keymap.set("n", "<leader>ft", builtin.live_grep, { desc = "Find text with telescope" })
			vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find git files with telescope" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags with telescope" })
		end,
	},

	-- Filetree
	{
		"nvim-tree/nvim-tree.lua",
		event = "VeryLazy",
		tag = "v0.99",
		config = function()
			require("nvim-tree").setup({
				sort = {
					sorter = "case_sensitive",
				},
				view = {
					width = 30,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = true,
				},
			})

			-- Auto close if last tab
			vim.api.nvim_create_autocmd("BufEnter", {
				nested = true,
				callback = function()
					if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
						vim.cmd("quit")
					end
				end,
			})

			vim.keymap.set(
				{ "n", "v" },
				"<leader>e",
				":NvimTreeToggle<CR>",
				{ desc = "Toggle file tree", silent = true }
			)
		end,
	},
}
