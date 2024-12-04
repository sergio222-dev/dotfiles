#!/bin/bash

# Get direction
direction=$1

# Get the focused  monitor
focused_monitor=$(hyprctl activeworkspace | grep "monitorID" | awk '{print $2}')

# Get the monitor array
monitor_count=$(xrandr -q | grep 'connected' | awk '{print $1}' | wc -l)
monitor_count=$((monitor_count - 1))

if [ "$direction" = "f" ]; then
	# Increment in 1
	focused_monitor=$((focused_monitor + 1))
fi

if [ "$direction" = "b" ]; then
	# Decrement in 1
	echo "Decrementing"
	focused_monitor=$((focused_monitor - 1))
fi

if [ "$focused_monitor" -gt "$monitor_count" ]; then
	focused_monitor=0
fi

if [ "$focused_monitor" -lt 0 ]; then
	echo "Reset"
	focused_monitor=$monitor_count
fi

hyprctl dispatch focusmonitor "$focused_monitor"
