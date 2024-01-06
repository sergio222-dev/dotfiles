#!/bin/bash
status=$(dunstctl is-paused)

if [ "$1" == "toggle" ]; then
    if [ "$status" == "true" ]; then
        dunstctl set-paused false
        echo "%{F#066}󰂚"
    elif [ "$status" == "false" ]; then
        dunstctl set-paused true
        echo "%{F#ff0}󰂛"
    else
        echo "Invalid status: $status"
        exit 1
    fi

    exit 0 # Exith with success

elif [ $# -eq 0 ]; then
    while true; do
        status=$(dunstctl is-paused)
        if [ "$status" == "true" ]; then
            echo "%{T4}%{F#ff0}󰂛"
        elif [ "$status" == "false" ]; then
            echo "%{T4}%{F#066}󰂚"
        else
            echo "Invalid status: $status"
            exit 1
        fi
        sleep 0.5
    done
else
    echo "Usage: $0 [toggle]"
    exit 1  # Exit with an error
fi
