return {
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
		},
		version = "1.*",
		opts = {
			keymap = { preset = "default" },

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
				default = { "lsp", "buffer", "snippets", "path", "copilot" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},

			fuzzy = { implementation = "lua" },
		},
		opts_extend = { "sources.default" },
	},
}
