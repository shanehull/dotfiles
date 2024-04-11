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
				[[                                   ┓                                   ]],
				[[                                   ┣┓╋┓┏┏                              ]],
				[[                                   ┗┛┗┗┻┛                              ]],
			}

			-- Set menu
			dashboard.section.buttons.val = {
				dashboard.button("nz", "🅩  > New Zettelkasten", ":Zet<CR>"),
				dashboard.button("fn", "󰈞  > Find Note", ":Telescope live_grep search_dirs=~/secondbrain<CR>"),
				dashboard.button("nf", "  > New File", ":ene <BAR> startinsert<CR>"),
				dashboard.button("ff", "󰈞  > Find File", ":Telescope find_files<CR>"),
				dashboard.button("ft", "  > Find Text", ":Telescope live_grep<CR>"),
				dashboard.button("r ", "> > Recent Files", ":Telescope oldfiles<CR>"),
				dashboard.button("u ", " > Update Plugins", ":Lazy update<CR>"),
				dashboard.button("q ", " > Quit", ":qa<CR>"),
			}

			-- Send config to alpha
			alpha.setup(dashboard.opts)
		end,
	},
}
