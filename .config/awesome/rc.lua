--[[

-- >> Sergio222.dev -- AWESOME Config
-- base lua rc https://github.com/elenapan/dotfiles/blob/master/config/awesome/rc.lua

--]]

local themes = {
  "default", -- 1 --
}
-- Select theme
local theme = themes[1]
-- ===========================================================================
-- User variables and preferences
user = {
  browser = "brave",
}

-- Initialization
-- ===========================================================================

-- Keybindings
local keys = require("keys")

-- Theme
local beautiful = require("beautiful")
local xrdb = beautiful.xresources.get_current_theme()

dpi = beautiful.xresources.apply_dpi
-- Make xresources colors global
x = {
  background = xrdb.background,
  foreground = xrdb.foreground,
  color0 = xrdb.color0,
  color1 = xrdb.color1,
  color2 = xrdb.color2,
  color3 = xrdb.color3,
  color4 = xrdb.color4,
  color5 = xrdb.color5,
  color6 = xrdb.color6,
  color7 = xrdb.color7,
  color8 = xrdb.color8,
  color9 = xrdb.color9,
  color10 = xrdb.color10,
  color11 = xrdb.color11,
  color12 = xrdb.color12,
  color13 = xrdb.color13,
  color14 = xrdb.color14,
  color15 = xrdb.color15,
}

-- Vars
local vars = require("vars")

-- Apps
local apps = require("apps")

-- Start up applications
local startup = require("startup")

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Load AwesomeWM libraries
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
--require('utils')

-- Notification library
local naughty = require("naughty")

-- Load theme
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme .. "/"
local loaded = beautiful.init(theme_dir .. "theme.lua")

-- Load Bling module
local bling = require("bling")

-- local defaultThemeDir = gears.filesystem.get_themes_dir() .. "default/theme.lua"

if not loaded then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Error loading theme",
    text = "Not loaded D: " .. theme_dir .. "theme.lua " .. gears.filesystem.get_themes_dir(),
  })
end

-- Decorations
local decorations = require("decorations")
decorations.init()

-- Widget and layout library
local wibox = require("wibox")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
-- local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors,
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then
      return
    end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err),
    })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.

-- This is used later as the default terminal and editor to run.
terminal = "warp-terminal"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.max,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  {
    "hotkeys",
    function()
      hotkeys_popup.show_help(nil, awful.screen.focused())
    end,
  },
  { "manual",      terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart",     awesome.restart },
  {
    "quit",
    function()
      awesome.quit()
    end,
  },
}

-- ======================================================================
-- Compnents
require("components.dashboard.dashboard")

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
  mymainmenu = freedesktop.menu.build({
    before = { menu_awesome },
    after = { menu_terminal },
  })
else
  mymainmenu = awful.menu({
    items = {
      menu_awesome,
      -- { "Debian", debian.menu.Debian_menu.Debian },
      menu_terminal,
    },
  })
end

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t)
    t:view_only()
  end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
  end),
  awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
  end)
)

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal("request::activate", "tasklist", { raise = true })
    end
  end),
  awful.button({}, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end)
)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", apps.set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper <=== we use bling for this
  -- apps.set_wallpaper()

  local l = awful.layout.suit

  local tagnames = beautiful.tagnames or { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

  local layouts = {
    l.tile,
    l.tile,
    l.tile,
    l.tile,
    l.tile,
    l.tile,
    l.tile,
    l.tile,
    l.tile,
    l.tile,
  }

  -- Each screen has its own tag table.
  awful.tag(tagnames, s, layouts)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 3, function()
      awful.layout.inc(-1)
    end),
    awful.button({}, 4, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 5, function()
      awful.layout.inc(-1)
    end)
  ))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
  })

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
  })

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup({
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      mylauncher,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    {             -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      mykeyboardlayout,
      wibox.widget.systray(),
      mytextclock,
      s.mylayoutbox,
    },
  })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({}, 3, function()
    mymainmenu:toggle()
  end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
clientbuttons = keys.clientbuttons

-- Set keys
-- root.keys(globalkeys)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
local rules = require("rules")
awful.rules.rules = rules
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- awful.titlebar(c):setup({
  --		{ -- Left
  --			awful.titlebar.widget.iconwidget(c),
  --			buttons = keys.titlebar_buttons,
  --			layout = wibox.layout.fixed.horizontal,
  --		},
  --		{ -- Middle
  --			{ -- Title
  --				align = "center",
  --				widget = awful.titlebar.widget.titlewidget(c),
  --			},
  --			buttons = keys.titlebar_buttons,
  --			layout = wibox.layout.flex.horizontal,
  --		},
  --		{ -- Right
  --			awful.titlebar.widget.floatingbutton(c),
  --			awful.titlebar.widget.maximizedbutton(c),
  --			awful.titlebar.widget.stickybutton(c),
  --			awful.titlebar.widget.ontopbutton(c),
  --			awful.titlebar.widget.closebutton(c),
  --			layout = wibox.layout.fixed.horizontal(),
  --		},
  --		layout = wibox.layout.align.horizontal,
  --	})
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)
-- }}}

-- ==================================================================
-- Startup applications
bling.module.wallpaper.setup({
  set_function = bling.module.wallpaper.setters.random,
  wallpaper = { vars.WALLPAPER_PATH },
  change_timer = 631, -- <=== use prime numbers
  position = "maximized",
  screen = screen,
  screens = screen,
  background = "#FAFAFA",
})
bling.widget.window_switcher.enable({
  type = "thumbnail", -- set to anything other than "thumbnail" to disable client previews

  -- keybindings (the examples provided are also the default if kept unset)
  hide_window_switcher_key = "Escape",                      -- The key on which to close the popup
  minimize_key = "n",                                       -- The key on which to minimize the selected client
  unminimize_key = "N",                                     -- The key on which to unminimize all clients
  kill_client_key = "q",                                    -- The key on which to close the selected client
  cycle_key = "Tab",                                        -- The key on which to cycle through all clients
  previous_key = "Left",                                    -- The key on which to select the previous client
  next_key = "Right",                                       -- The key on which to select the next client
  vim_previous_key = "h",                                   -- Alternative key on which to select the previous client
  vim_next_key = "l",                                       -- Alternative key on which to select the next client

  cycleClientsByIdx = awful.client.focus.byidx,             -- The function to cycle the clients
  filterClients = awful.widget.tasklist.filter.currenttags, -- The function to filter the viewed clients
})

startup.init()
