local wezterm = require("wezterm")
local act = wezterm.action
local config = {}
require("on")

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Frappe"
config.hide_tab_bar_if_only_one_tab = false

-- config.window_background_image = '/home/sergio/Pictures/wallpapers/deaths-gambit-artwork.jpg'
config.window_background_image_hsb = {
	brightness = 0.01,

	hue = 1.0,

	saturation = 1.0,
}
config.window_background_opacity = 0.8
config.text_background_opacity = 1
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.default_cursor_style = "SteadyBar"
config.cursor_thickness = 1
config.window_padding = {
	left = 8,
	right = 8,
	top = 8,
	bottom = 8,
}

--------------------------------------------------
--#region keybindings
--------------------------------------------------
config.keys = {}

for i = 1, 8 do
	-- F1 through F8 to activate that tab
	table.insert(config.keys, {
		key = "F" .. tostring(i),
		action = act.ActivateTab(i - 1),
	})
end

--#endregion

return config
