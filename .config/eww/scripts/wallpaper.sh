#!/bin/bash

ewwPath="$HOME/.config/eww"

wallPath="$ewwPath/images/currentwall"

function set_background() {
	if [ ! -d $HOME/Pictures ]; then
		mkdir $HOME/Pictures
	fi

	if [ ! -d $HOME/Pictures/wallpapers ]; then
		mkdir $HOME/Pictures/wallpapers
	fi

	# Get list of the path
	# Chose a wallpaper
	path=$(ls -1 $HOME/Pictures/wallpapers/* | shuf -n 1)

	# Create link to the original source
	rm -f $wallPath/*
	ln -s $path $wallPath/currentwall

	# Create wal colors
	wal -i $wallPath/currentwall

	# Create Blurred version
	convert $wallPath/currentwall -blur 0x8 $wallPath/currentwall_blur

	# Set wallpaper
	feh --bg-fill $path
}

if [[ $1 == "--set-wall" ]]; then
	set_background
elif [[ $1 == "--get-blur-wall" ]]; then
	echo "$wallPath/currentwall_blur"
fi
