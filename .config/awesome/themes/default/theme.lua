local theme_name = "default"

local gears = require("gears")
local apps = require("apps")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
-- local defaultThemeDir = gears.filesystem.get_themes_dir() .. "default/theme.lua"

local originalPackagePath = package.path
package.path = ";/usr/share/awesome/themes/default/?.lua"

-- base theme
local t = require("theme")

package.path = originalPackagePath

local theme = t

theme.font = "monospace 11"

theme.border_normal = x.background
theme.border_focus = x.foreground

theme.border_radius = dpi(14)

theme.border_width = dpi(4)

theme.useless_gap = dpi(15)

-- theme.wallpaper = apps.set_wallpaper

-- Dashboard
theme.dashboard_bg = x.background .. "CC"
theme.dashboard_fg = x.foreground .. "CC"

return theme
