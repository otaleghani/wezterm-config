local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
local selected_scheme = "Catppuccin Mocha"
config.color_scheme = selected_scheme

config.window_background_opacity = 1.0
config.font = wezterm.font("JetBrains Mono")
config.font_size = 10.0
config.default_prog = { "powershell.exe" }

-- Prints the active workspace
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

-- Start tabs ricing
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

scheme = wezterm.get_builtin_color_schemes()[selected_scheme]
local C_ACTIVE_BG = scheme.selection_bg
local C_ACTIVE_FG = scheme.ansi[0]
local C_BG = scheme.background
local C_HL_1 = scheme.ansi[5]
local C_HL_2 = scheme.ansi[4]
local C_INACTIVE_FG
local bg = wezterm.color.parse(scheme.background)
local h, s, l, a = bg:hsla()
if l > 0.5 then
	C_INACTIVE_FG = bg:complement_ryb():darken(0.3)
else
	C_INACTIVE_FG = bg:complement_ryb():lighten(0.3)
end

scheme.tab_bar = {
	background = C_BG,
	new_tab = {
		bg_color = C_BG,
		fg_color = C_HL_2,
	},
	active_tab = {
		bg_color = C_ACTIVE_BG,
		fg_color = C_ACTIVE_FG,
	},
	inactive_tab = {
		bg_color = C_BG,
		fg_color = C_INACTIVE_FG,
	},
	inactive_tab_hover = {
		bg_color = C_BG,
		fg_color = C_INACTIVE_FG,
	},
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	if tab.is_active then
		return {
			{ Foreground = { Color = C_HL_1 } },
			{ Text = " " .. tab.tab_index + 1 },
			{ Foreground = { Color = C_HL_2 } },
			{ Text = ": " },
			{ Foreground = { Color = C_ACTIVE_FG } },
			{ Text = tab.active_tab.title .. " " },
			{ Background = { Color = C_BG } },
			{ Foreground = { Color = C_HL_1 } },
			{ Text = "|" },
		}
	end
	return {
		{ Foreground = { Color = C_HL_1 } },
		{ Text = " " .. tab.tab_index + 1 },
		{ Foreground = { Color = C_HL_2 } },
		{ Text = ": " },
		{ Foreground = { Color = C_INACTIVE_FG } },
		{ Text = tab.active_tab.title .. " " },
		{ Foreground = { Color = C_HL_1 } },
		{ Text = "|" },
	}
end)
-- End tabs ricing

-- Remaps
config.keys = {
	-- Misc
	{ key = "F11", mods = "", action = wezterm.action.ToggleFullScreen },
	{ key = "F12", mods = "", action = wezterm.action.EmitEvent("toggle-tabbar") },

	-- Workspaces
	-- { key = "w", mods = "CTRL|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{ key = "n", mods = "CTRL|SHIFT|ALT", action = act.SwitchWorkspaceRelative(1) },
	{ key = "p", mods = "CTRL|SHIFT", action = act.SwitchWorkspaceRelative(-1) },

	-- Tabs
	{ key = "q", mods = "CTRL", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "n", mods = "CTRL|SHIFT", action = act.SpawnTab("DefaultDomain") },
	{ key = "o", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "i", mods = "CTRL", action = act.ActivateTabRelative(-1) },
	{ key = "o", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },
	{ key = "i", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = "1", mods = "CTRL|SHIFT", action = act.MoveTab(0) },
	{ key = "2", mods = "CTRL|SHIFT", action = act.MoveTab(1) },
	{ key = "3", mods = "CTRL|SHIFT", action = act.MoveTab(2) },
	{ key = "4", mods = "CTRL|SHIFT", action = act.MoveTab(3) },
	{ key = "5", mods = "CTRL|SHIFT", action = act.MoveTab(4) },
	{ key = "6", mods = "CTRL|SHIFT", action = act.MoveTab(5) },
	{ key = "7", mods = "CTRL|SHIFT", action = act.MoveTab(6) },
	{ key = "8", mods = "CTRL|SHIFT", action = act.MoveTab(7) },
	{ key = "9", mods = "CTRL|SHIFT", action = act.MoveTab(8) },
	-- { key = '0', mods = 'CTRL|SHIFT', action = act.MoveTab(9) },
	{ key = "1", mods = "CTRL", action = act.ActivateTab(0) },
	{ key = "2", mods = "CTRL", action = act.ActivateTab(1) },
	{ key = "3", mods = "CTRL", action = act.ActivateTab(2) },
	{ key = "4", mods = "CTRL", action = act.ActivateTab(3) },
	{ key = "5", mods = "CTRL", action = act.ActivateTab(4) },
	{ key = "6", mods = "CTRL", action = act.ActivateTab(5) },
	{ key = "7", mods = "CTRL", action = act.ActivateTab(6) },
	{ key = "8", mods = "CTRL", action = act.ActivateTab(7) },
	{ key = "9", mods = "CTRL", action = act.ActivateTab(8) },
	-- { key = '0', mods = 'CTRL', action = act.ActivateTab(9) },
	{
		key = "r",
		mods = "CTRL",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Panes
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.SplitPane({ direction = "Left", command = {}, size = { Percent = 50 } }),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.SplitPane({ direction = "Right", command = {}, size = { Percent = 50 } }),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = act.SplitPane({ direction = "Up", command = {}, size = { Percent = 50 } }),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = act.SplitPane({ direction = "Down", command = {}, size = { Percent = 50 } }),
	},
	{ key = "h", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "CTRL", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "CTRL", action = act.ActivatePaneDirection("Down") },
	{ key = "z", mods = "CTRL", action = act.TogglePaneZoomState },

	-- Copy/Pasting
	{ key = "y", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "p", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
}
-- End remaps

-- Start toggle tabs
wezterm.on("toggle-tabbar", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if overrides.enable_tab_bar == false then
		wezterm.log_info("tab bar shown")
		overrides.enable_tab_bar = true
	else
		wezterm.log_info("tab bar hidden")
		overrides.enable_tab_bar = false
	end
	window:set_config_overrides(overrides)
end)
-- End toggle tabs

config.background = {
	{
		source = {
			File = "C:\\Users\\Oliviero\\Pictures\\Wallpaper\\mpv-shot0009.jpg",
		},
	},
	{
		source = {
			Color = "rgba(30, 30, 46, 0.90)",
		},
		height = "100%",
		width = "100%",
	},
}

return config
