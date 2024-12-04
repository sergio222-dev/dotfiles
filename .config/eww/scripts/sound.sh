#!/bin/bash

function set_volume() {
	#   echo $1 >~/test.t
	pactl set-sink-volume @DEFAULT_SINK@ $1%
}

function get_volume() {
	echo $(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d "%")
}

if [[ $1 == "--set-vol" ]]; then
	set_volume $2
elif [[ $1 == "--get-vol" ]]; then
	get_volume
fi
