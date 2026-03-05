return {
	{
		"saghen/blink.compat",
		version = "2.*",
		lazy = true,
		opts = {},
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			{
				{
					"L3MON4D3/LuaSnip",
					version = "v2.*",
					{ "L3MON4D3/LuaSnip", version = "v2.*" },
				},
			},
			"rafamadriz/friendly-snippets",
			"fang2hou/blink-copilot",
			"moyiz/blink-emoji.nvim",
		},
		version = "1.*",
		opts = {
			keymap = {
				preset = "default",
				["<Tab>"] = {
					function(cmp)
						if vim.b[vim.api.nvim_get_current_buf()].nes_state then
							cmp.hide()
							return (
								require("copilot-lsp.nes").apply_pending_nes()
								and require("copilot-lsp.nes").walk_cursor_end_edit()
							)
						end
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
			},

			appearance = {
				nerd_font_variant = "hack",
			},

			signature = { enabled = true },

			completion = { documentation = { auto_show = false } },

			cmdline = {
				keymap = { preset = "inherit" },
				completion = { menu = { auto_show = true } },
			},

			snippets = { preset = "luasnip" },

			sources = {
				default = {
					"lsp",
					"buffer",
					"snippets",
					"path",
					"copilot",
					"emoji",
				},
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer" },
				},
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
					dadbod = {
						name = "dadbod",
						module = "vim_dadbod_completion.blink",
					},
					emoji = {
						module = "blink-emoji",
						name = "emoji",
						score_offset = 15,
						opts = {
							insert = true,
							---@type string|table|fun():table
							trigger = function()
								return { ":" }
							end,
						},
					},
				},
			},

			fuzzy = { implementation = "lua" },
		},
		opts_extend = { "sources.default" },
	},
}
