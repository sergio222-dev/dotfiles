#!/bin/bash

workspace_in_main_monitor="DP-0"
direction_left=left
direction_right=right

current_workspace=$(i3-msg -t get_workspaces | jq '.[] | select(.output=="DP-0") | select(.visible==true) | .num')
# remove \n from the i3 json response
formatted=$(echo "$current_workspace" | tr -d '\n')
current_workspace_num=$((formatted))

# parse arguemtns
selected_direction=$1
shift
other_workspaces=("$@")

recover_workspace_name () {
    workspace_name=$
    workspace_name=${other_workspaces[$1]}
}

move_to_workspace_number () {
    recover_workspace_name $(($1-1))
    echo "moving to workspace $workspace_name"
    i3-msg workspace "$workspace_name" 1> /dev/null
}


if [[ $selected_direction == $direction_left  ]]; then
    if [[ $current_workspace_num == 1 ]]; then
        move_to_workspace_number 9
        move_to_workspace_number 10
    else
        move_to_workspace_number $(($current_workspace_num-1))
        move_to_workspace_number $(($current_workspace_num-2))
    fi

    exit
fi

if [[ $selected_direction == $direction_right ]]; then
    if [[ $current_workspace_num == 9 ]]; then
        move_to_workspace_number 1
        move_to_workspace_number 2
    else
        move_to_workspace_number $(($current_workspace_num+2))
        move_to_workspace_number $(($current_workspace_num+3))
    fi

    exit
fi
