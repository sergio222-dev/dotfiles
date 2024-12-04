#!/bin/bash

if [[ $# -eq 0 ]]; then
	echo "No arguments provided"
	exit 1
fi

DEBUG=true
TMP_PATH="/tmp"
DEFAULT_SLEEP_TIME=0.2
TMP_FILE="$TMP_PATH/z_$1"
EWW_WINDOW="$1"
shift

# Dialog values
DIALOG_TEXT=""
ON_YES=""
ON_NO=""

while [[ "$#" -gt 0 ]]; do
	case $1 in
	--on-yes=*)
		ON_YES="${1#*=}"
		shift
		;;
	--on-no=*)
		ON_NO="${1#*=}"
		shift
		;;
	--text=*)
		DIALOG_TEXT="${1#*=}"
		shift
		;;
	esac
done

function log() {
	if $DEBUG; then
		echo "$1"
	fi
}

function get_script_path() {
	local SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
	local TARGET_SCRIPT="$SCRIPT_DIR/$1"

	echo "$TARGET_SCRIPT"
}

function is_window_open() {
	IS_WINDOW_OPEN=$(eww list-windows | grep '*' | grep '$EWW_WINDOW' | tr -d '*')

	if [[ -z "$IS_WINDOW_OPEN" ]]; then
		return 1
	fi

	return 0
}

function toggle_dialog() {
	if $1; then
		log "Opening dialog window with options $ON_YES and $ON_NO"
		command eww open "$2" --arg onyes="$ON_YES" --arg onno="$ON_NO" --arg text="$DIALOG_TEXT"
	else
		command eww close "$2"
	fi
}

function toggle_menu() {
	if $1; then
		log "Opening window menu"
		command eww update SHOW_MENU=true
		command eww open "$2"
	else
		command eww update SHOW_MENU=false
		sleep $DEFAULT_SLEEP_TIME
		command eww close "$2"
	fi
}

function toggle_settings() {
	if $1; then
		log "Opening window settings"

		local SINK_SCRIPT=$(get_script_path "/sound/sinks.sh")

		# Getting the initial sound system
		local INITIAL_SOUND=$("$SINK_SCRIPT" --get-vol)

		# Geting a json from the current sound cards and which is the active
		local JSON_SINKS=$("$SINK_SCRIPT" --get-json-sinks)

		command eww update sound_system="$INITIAL_SOUND"
		command eww update sound_cards="$JSON_SINKS"
		command eww update SHOW_SETTINGS=true
		command eww open "$2"
	else
		command eww update SHOW_SETTINGS=false
		sleep $DEFAULT_SLEEP_TIME
		command eww close "$2"
	fi
}

function window_exists() {
	WINDOW_EXISTS=$(eww list-windows | grep "$EWW_WINDOW")

	if [[ -z "$WINDOW_EXISTS" ]]; then
		return 1
	fi

	return 0
}

function handle_window_launch() {
	case "$EWW_WINDOW" in
	menu)
		toggle_menu $1 "$EWW_WINDOW"
		;;

	settings)
		toggle_settings $1 "$EWW_WINDOW"
		;;
	dialog_window)
		toggle_dialog $1 "$EWW_WINDOW"
		;;
	*)
		echo "Unknown window"
		;;
	esac
}

toggle() {
	if ! window_exists; then
		echo "Unknown window"
		echo "Try with one of this windows"
		command eww list-windows
		return 0
	fi

	if [ ! -f "$TMP_FILE" ]; then
		if is_window_open; then
			exit
		fi
		touch "$TMP_FILE"
		log "Created temporal file $TMP_FILE"

		handle_window_launch true
		#		${eww} -c $ewwPath update SHOW_WIDGET=true
	else
		rm "$TMP_FILE"
		handle_window_launch false
	fi
}

toggle
