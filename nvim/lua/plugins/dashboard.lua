return {
	{
		"goolord/alpha-nvim",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Set header
			dashboard.section.header.val = {
				[[                                                                       ]],
				[[                                                                       ]],
				[[                                                                       ]],
				[[                                                                       ]],
				[[                                                                       ]],
				[[                                                                       ]],
				[[                                                                       ]],
				[[                                                                     ]],
				[[       ████ ██████           █████      ██                     ]],
				[[      ███████████             █████                             ]],
				[[      █████████ ███████████████████ ███   ███████████   ]],
				[[     █████████  ███    █████████████ █████ ██████████████   ]],
				[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
				[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
				[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
				[[                                                                       ]],
				[[                                                                       ]],
				[[                                                                       ]],
			}

			-- Set menu
			dashboard.section.buttons.val = {
				dashboard.button("n", "  > New file", ":ene <BAR> startinsert<CR>"),
				dashboard.button("s", "󰈞  > Find file", ":Telescope find_files<CR>"),
				dashboard.button("t", "  > Find text", ":Telescope live_grep<CR>"),
				dashboard.button("r", "  > Recent files", ":Telescope oldfiles<CR>"),
				dashboard.button("u", " > Update Plugins", ":Lazy update<CR>"),
				dashboard.button("q", " > Quit NVIM", ":qa<CR>"),
			}

			-- Send config to alpha
			alpha.setup(dashboard.opts)
		end,
	},
}
