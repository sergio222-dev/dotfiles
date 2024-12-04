local helpers = require("helpers")
local vars = require("vars")

local awful = require("awful")

local apps = {}

apps.rofi = function()
	awful.spawn.with_shell("~/.config/rofi/launchers/type-7/launcher.sh")
end

apps.powermenu = function()
	awful.spawn.with_shell("~/.config/rofi/powermenu/type-1/powermenu.sh")
end

apps.screenshot = function()
	awful.spawn.with_shell("flameshot gui")
end

apps.set_wallpaper = function()
	awful.spawn.with_shell(vars.BIN_PATH .. "/wallpaper --set-wall")
end

apps.clipboard = function()
	awful.spawn.with_shell("clipcat-menu")
end

apps.discord = function()
	helpers.run_or_raise({ class = "discord" }, false, "discord")
end

apps.thunderbird = function()
	helpers.run_or_raise({ class = "thunderbird" }, false, "thunderbird")
end

apps.picom = function()
	awful.spawn.with_shell(
		"sh -c 'pgrep picom > /dev/null && pkill picom || picom --experimental-backends --xrender-sync-fence --config ~/.config/picom.conf & disown'"
	)
end

return apps
