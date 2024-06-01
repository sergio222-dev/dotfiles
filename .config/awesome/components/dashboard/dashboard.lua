local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local naughty = require("naughty")


local box_radius = beautiful.dashboard_box_radius or dpi(8)
local box_gap = beautiful.dashboard_box_gap or dpi(8)

local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

local dashboard = wibox({
    visible = false,
    ontop = true,
    type = "dock",
    screen = screen.primary,
})

dashboard.bg = beautiful.dashboard_bg or "#FAFAFACC"

awful.placement.maximize(dashboard)

-- Mouse bindings
--dashboard:buttons(gears.table.join(
--    awful.button({}, 1, function()
--        dashboard_hide()
--    end)
--))

awful.screen.connect_for_each_screen(function(s)
    if s == screen.primary then
        s.dashboard = dashboard
    else
        s.dashboard = helpers.screen_mask(s, beautiful.dashboard_bg or "#FAFAFACC")
    end
end)

local function set_visibility(v)
    for s in screen do
        if s.dashboard then
            s.dashboard.visible = v
        end
    end
end


-- helper function to create a centered box with margins
local function create_boxed_widget(widget, width, height, bg_color)
    local bg_widget = wibox.container.background()
    bg_widget.bg = bg_color
    bg_widget.forced_width = width
    bg_widget.forced_height = height
    bg_widget.shape = helpers.rrect(box_radius)

    local w = wibox.widget({
        {
            {
                nil,
                {
                    nil,
                    widget,
                    widget = wibox.layout.align.vertical,
                    expand = "none"
                },
                widget = wibox.layout.align.horizontal,
                expand = "none",
            },
            widget = bg_widget,
        },
        bg = "#FF000000",
        margins = box_gap,
        widget = wibox.container.margin,
    })

    return w
end

-- Notification Widget
local notification_state = wibox.widget {
    align = "center",
    valign = "center",
    font = "DejaVu Sans 24",
    widget = wibox.widget.textbox(" 󰂚 ")
}

local function update_notification_state_icon()
    if naughty.is_suspended() then
        notification_state.markup = helpers.colorize_text(notification_state.text, x.color8)
    else
        notification_state.markup = helpers.colorize_text(notification_state.text, x.color2)
    end
end
update_notification_state_icon()

local notification_state_box = create_boxed_widget(notification_state, dpi(150), dpi(150), x.background)

notification_state_box:buttons(gears.table.join(
    awful.button({}, 1, function()
        naughty.toggle()
        update_notification_state_icon()
    end)
))


-- Volume Widget
local max_volume = 150
local volume_value = 0;
local get_volume_value = function()
    awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout)
        volume_value = tonumber(stdout)
    end)
end
local set_volume_value = function(volume)
    awful.spawn.with_shell("pamixer --allow-boost --set-volume " .. volume)
end

local volume_bar_widget = wibox.widget {
    maximum = max_volume,
    minimum = 0,
    widget = wibox.widget.slider,
}

volume_bar_widget:connect_signal("property::value", function()
    naughty.notify({
        preset = naughty.config.presets.low,
        title = "Debug",
        text = "Volume: " .. volume_bar_widget.value
    })
end)



-- ===========================================
-- =========== Dashboard ==============
-- ==========================================

dashboard:setup {
    nil,
    {
        nil,
        notification_state_box,
        volume_bar_widget,
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
}

local dashboard_grabber

function dashboard_hide()
    awful.keygrabber.stop(dashboard_grabber)
    set_visibility(false)
end

function dashboard_show()
    dashboard_grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        -- Press Escape or q or F1 to hide it
        if key == 'Escape' or key == 'q' or key == 'F1' then
            dashboard_hide()
        end
    end)
    set_visibility(true)
end
