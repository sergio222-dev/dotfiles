local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local helpers = {}

-- Create rounded rectangle shape (in one line)
helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

function helpers.run_or_raise(match, move, spawn_cmd, spawn_args, is_with_shell)
    local matcher = function(c)
        return awful.rules.match(c, match)
    end

    -- Find and raises
    local found = false
    for c in awful.client.iterate(matcher) do
        found = true
        c.minimized = true
        if move then
            c:move_to_tag(mouse.screen.selected_tag)
            client.focus = c
        else
            c:jump_to()
        end
    end

    -- spawn if not found
    if not found then
        if is_with_shell then
            awful.spawn.with_shell(spawn_cmd, spawn_args)
        else
            awful.spawn(spawn_cmd, spawn_args)
        end
    end
end

-- Colorize text with pango markup
function helpers.colorize_text(text, color)
    return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

function helpers.screen_mask(s, bg)
    local mask = wibox({
        visible = false,
        ontop = true,
        screen = s,
        bg = bg,
        type = "splash",
    })

    awful.placement.maximize(mask)

    return mask
end


return helpers
