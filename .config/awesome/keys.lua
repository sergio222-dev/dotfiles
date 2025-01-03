local gears = require("gears")
local awful = require("awful")
local apps = require("apps")
local naughty = require("naughty")

local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")
local bling = require("bling")

local keys = {}

local resize_mode_grabber
local move_mode_grabber

function exit_resize_mode()
	awful.keygrabber.stop(resize_mode_grabber)
end

function exit_move_mode()
	awful.keygrabber.stop(move_mode_grabber)
end

-- Mod keys
modkey = "Mod4"
altkey = "Mod1"
ctrlkey = "Control"
shiftkey = "Shift"

local term_scratch = bling.module.scratchpad({
	command = "kitty", -- How to spawn the scratchpad
	rule = { instance = "kitty" }, -- The rule that the scratchpad will be searched by
	sticky = true, -- Whether the scratchpad should be sticky
	autoclose = false, -- Whether it should hide itself when losing focus
	floating = true, -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
	geometry = { x = 360, y = 90, height = 900, width = 1200 }, -- The geometry in a floating state
	reapply = true, -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
	dont_focus_before_close = false, -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
})

-- {{{ key bidings
keys.globalkeys = gears.table.join(
	-- ==================================================================================
	-- i3 and simple configurations
	awful.key({ modkey }, "d", function()
		apps.rofi()
	end, { description = "open rofi menu", group = "i3" }),
	awful.key({ modkey }, "F4", function()
		apps.powermenu()
	end, { description = "open powermenu", group = "i3" }),
	awful.key({}, "Print", function()
		apps.screenshot()
	end, { description = "take a screenshot", group = "i3" }),
	awful.key({ altkey }, "Tab", function()
		awesome.emit_signal("bling::window_switcher::turn_on")
	end, { description = "Window Switcher", group = "i3" }),
	awful.key({ modkey }, "v", function()
		apps.clipboard()
	end, { description = "clipboard manager with rofi", group = "i3" }),

	-- Scratchpad
	awful.key({ modkey }, "-", function()
		term_scratch:toggle()
	end, { description = "toggle scratchpad", group = "i3" }),

	-- Dashboard

	awful.key({ modkey }, "b", function()
		if dashboard_show then
			dashboard_show()
		end
	end, { description = "open dashboard", group = "i3" }),
	-- ==================================================================================
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
		mouse.coords({
			x = awful.client.focus.x,
			y = awful.client.focus.y,
		})
	end, { description = "focus next by index", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),
	awful.key({ modkey }, "w", function()
		mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),

	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),

	-- Standard program
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ modkey }, "r", function()
		awful.screen.focused().mypromptbox:run()
	end, { description = "run prompt", group = "launcher" }),

	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),
	-- Menubar
	awful.key({ modkey }, "p", function()
		menubar.show()
	end, { description = "show the menubar", group = "launcher" })
)

for i = 1, 9 do
	keys.globalkeys = gears.table.join(
		keys.globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

-- Mouse buttons on title bars
keys.titlebar_buttons = gears.table.join(
	awful.button({}, 1, function()
		local c = mouse.object_under_pointer()
		c:emit_signal("request::activate", "titlebar", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({}, 3, function()
		local c = mouse.object_under_pointer()
		c:emit_signal("request::activate", "titlebar", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Client keys
keys.clientkeys = gears.table.join(
	awful.key({ modkey }, "a", function(c)
		if not c.floating then
			return
		end
		naughty.notify({
			title = "Enter in Move Mode",
			timeout = 5,
		})
		move_mode_grabber = awful.keygrabber.run(function(_, key, event)
			if event == "release" then
				return
			end

			if key == "h" then
				local new_x = c.x - 100
				c:geometry({ x = new_x, y = c.y, width = c.width, height = c.height })
			end

			if key == "j" then
				local new_y = c.y - 100
				c:geometry({ x = c.x, y = new_y, width = c.width, height = c.height })
			end

			if key == "k" then
				local new_y = c.y + 100
				c:geometry({ x = c.x, y = new_y, width = c.width, height = c.height })
			end

			if key == "l" then
				local new_x = c.x + 100
				c:geometry({ x = new_x, y = c.y, width = c.width, height = c.height })
			end

			if key == "Esc" or key == "q" then
				awful.keygrabber.stop(move_mode_grabber)
			end
		end)
	end, { description = "Enter in Move Mode", group = "client" }),
	awful.key({ modkey }, "i", function(c)
		if not c.floating then
			return
		end
		naughty.notify({
			title = "Enter in Resize Mode",
			timeout = 5,
		})
		resize_mode_grabber = awful.keygrabber.run(function(_, key, event)
			if event == "release" then
				return
			end
			if key == "l" then
				local new_width = c.width + 100
				c:geometry({ x = c.x, y = c.y, width = new_width, height = c.height })
			end

			if key == "h" then
				local new_width = c.width - 100
				c:geometry({ x = c.x, y = c.y, width = new_width, height = c.height })
			end

			if key == "j" then
				local new_height = c.height + 100
				c:geometry({ x = c.x, y = c.y, width = c.width, height = new_height })
			end

			if key == "k" then
				local new_height = c.height - 100
				c:geometry({ x = c.x, y = c.y, width = c.width, height = new_height })
			end

			if key == "Escape" or key == "q" then
				exit_resize_mode()
			end
		end)
	end, { description = "Enter in Resize Mode", group = "client" }),
	awful.key({ modkey }, "y", function(c)
		c.sticky = not c.sticky
	end, { description = "toggle sticky", group = "client" }),
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey, "Shift" }, "c", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),
	awful.key({ modkey }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "minimize", group = "client" }),
	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" }),
	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(un)maximize horizontally", group = "client" })
)

keys.clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

root.keys(keys.globalkeys)

return keys
