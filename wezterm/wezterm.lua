local wezterm = require("wezterm")

return {
	leader = { key = "s", mods = "CTRL", timeout_milliseconds = 2000 },
	front_end = "WebGpu",

	color_scheme = "Gruvbox dark, medium (base16)",
	enable_tab_bar = false,
	window_background_opacity = 0.90,
	font_size = 12.0,
	font = wezterm.font("Hack Nerd Font"),

	set_environment_variables = {
		TERMINFO_DIRS = "/etc/profiles/per-user/$USER/share/terminfo",
		WSLENV = "TERMINFO_DIRS",
	},

	term = "wezterm",

	window_decorations = "RESIZE",

	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = true,

	default_prog = {
		"/bin/zsh",
		"-l",
	},

	audible_bell = "Disabled",

	keys = {
		-- Split panes
		{
			key = "%",
			mods = "LEADER|SHIFT",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = '"',
			mods = "LEADER",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		-- Pane navigation
		{
			key = "h",
			mods = "LEADER",
			action = wezterm.action.ActivatePaneDirection("Left"),
		},
		{
			key = "j",
			mods = "LEADER",
			action = wezterm.action.ActivatePaneDirection("Down"),
		},
		{
			key = "k",
			mods = "LEADER",
			action = wezterm.action.ActivatePaneDirection("Up"),
		},
		{
			key = "l",
			mods = "LEADER",
			action = wezterm.action.ActivatePaneDirection("Right"),
		},
		{
			key = "-",
			mods = "LEADER",
			action = wezterm.action.ActivatePaneDirection("Right"),
		},
		-- Activate copy mode
		{
			key = "[",
			mods = "LEADER",
			action = wezterm.action.ActivateCopyMode,
		},
	},
}
