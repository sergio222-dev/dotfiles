local wezterm = require("wezterm")
local mux = wezterm.mux
local gui = wezterm.gui
local act = wezterm.action
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "SynthwaveAlpha"

config.hide_tab_bar_if_only_one_tab = true

-- config.window_background_image = '/home/sergio/Pictures/wallpapers/deaths-gambit-artwork.jpg'

config.window_background_image_hsb = {
	brightness = 0.01,

	hue = 1.0,

	saturation = 1.0,
}

config.window_background_opacity = 0.9
config.text_background_opacity = 1
config.enable_tab_bar = false

config.tab_bar_at_bottom = true

config.default_cursor_style = "SteadyBar"
config.cursor_thickness = 1

config.window_padding = {
	left = 8,
	right = 8,
	top = 8,
	bottom = 8,
}

config.keys = {}
for i = 1, 8 do
	-- F1 through F8 to activate that tab
	table.insert(config.keys, {
		key = "F" .. tostring(i),
		action = act.ActivateTab(i - 1),
	})
end

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	return "💀 Wez [" .. pane.title .. "]"
end)

return config