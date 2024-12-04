local apps = require("apps")
local awful = require("awful")

local startup = {}

-- Initialize all the apps
startup.init = function()
    --apps.thunderbird()
    apps.discord()
--     apps.picom()
    awful.spawn.with_shell("dex -a -e awesome & disown")
end

return startup
