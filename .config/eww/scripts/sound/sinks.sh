function get_sinks_status_as_json() {
	# Geting a json from the current sound cards and which is the active
	local DEFAULT_SINK=$(pactl get-default-sink)

	local JSON_SINKS=$(pactl list sinks | awk -v default_sink="$DEFAULT_SINK" '
  /^Sink #[0-9]+$/ {
    # Capture the sink number and remove the # character
    sink_number = $2
    sub(/^#/, "", sink_number)
  }
  /Name:/ {
    is_active = ($2 == default_sink) ? "true" : "false"
  }
  /alsa.card_name/ { 
    # Capture everything after "alsa.card_name = " and remove the surrounding quotes
    match($0, /alsa.card_name = "(.*)"/, arr)
    card_name = arr[1]
    print "{ \"id\": \"" sink_number "\", \"name\": \"" card_name "\", \"active\":  " is_active " }"
  }
' | jq -s)

	echo $JSON_SINKS
}

function get_default_sink_volume() {
	# Getting the initial sound system
	local INITIAL_SOUND=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d "%")

	echo $INITIAL_SOUND
}

function update_eww_sinks() {
	SINKS_JSON=$(get_sinks_status_as_json)

	command eww update sound_cards="$SINKS_JSON"
}

ARG1=$1

HELP="The next commands are allowed

    --get-vol             Return the current default volume
    --get-json-sinks      Return a json that represent the current sinks status
    --update-eww-sinks    Update the sound_cards variable in eww
"

case "$1" in
--get-vol)
	get_default_sink_volume
	;;
--get-json-sinks)
	get_sinks_status_as_json
	;;
--update-eww-sinks)
	update_eww_sinks
	;;
--help)
	echo "$HELP"
	;;
esac
