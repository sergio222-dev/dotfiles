#!/bin/bash

if ! command -v pactl &>/dev/null; then
	echo "no pactl found"
	exit 1
fi

pactl subscribe | while read line; do
	SINK_NUMBER=$(echo $line | grep sink | grep change)

	if [[ -z "$SINK_NUMBER" ]]; then
		continue
	fi

	SINK_NUMBER=$(echo "$SINK_NUMBER" | awk '{print $5}' | tr -d '#')

	SINK_VOLUME=$(pactl get-sink-volume "$SINK_NUMBER" 2>/dev/null | awk '{print $5}' | tr -d '%\n' 2>/dev/null)

	if [[ -z "$SINK_VOLUME" ]]; then
		continue
	fi

	echo "$SINK_VOLUME"

done
