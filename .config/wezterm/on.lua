local wezterm = require("wezterm")
local utils = require("utils")

local scheme = wezterm.get_builtin_color_schemes()["Catppuccin Frappe"]

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_left_half_circle_thick

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_right_half_circle_thick

-- selene: allow(unused_variable)
---@diagnostic disable-next-line: unused-local
local function create_tab_title(tab, tabs, panes, configtab, hover, max_width)
	local user_title = tab.active_pane.user_vars.panetitle
	if user_title ~= nil and #user_title > 0 then
		return tab.tab_index + 1 .. ":" .. user_title
	end
	-- pane:get_foreground_process_info().status

	local title = wezterm.truncate_right(utils.basename(tab.active_pane.foreground_process_name), max_width)
	if title == "" then
		local dir = string.gsub(tab.active_pane.title, "(.*[: ])(.*)]", "%2")
		dir = utils.convert_useful_path(dir)
		title = wezterm.truncate_right(dir, max_width)
	end

	local copy_mode, n = string.gsub(tab.active_pane.title, "(.+) mode: .*", "%1", 1)
	if copy_mode == nil or n == 0 then
		copy_mode = ""
	else
		copy_mode = copy_mode .. ": "
	end
	--return copy_mode .. tab.tab_index + 1 .. ":" .. title
	return copy_mode .. title
end

-- on
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = scheme.tab_bar.inactive_tab_edge
	local background = scheme.tab_bar.inactive_tab.bg_color
	local foreground = scheme.tab_bar.inactive_tab.fg_color

	if tab.is_active then
		background = scheme.tab_bar.active_tab.bg_color
		foreground = scheme.tab_bar.active_tab.fg_color
	elseif hover then
		background = scheme.tab_bar.inactive_tab_hover.bg_color
		foreground = scheme.tab_bar.inactive_tab_hover.fg_color
	end

	local edge_foreground = background

	local title = create_tab_title(tab, tabs, panes, config, hover, max_width)
	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	return "💀 Wez [" .. pane.title .. "]"
end)
