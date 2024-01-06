#!/bin/bash
eww="$HOME/eww/target/release/eww"
ewwPath="$HOME/.config/eww"
tmpPath="$HOME/.cache/eww"
tmpFile="$tmpPath/z_launch"
if [ ! -d $tmpPath ]; then
	mkdir $tmpPath
fi

windows="window_left"

toggle() {

	#isDaemonRunning=$(eww -c $ewwPath ping 2> >(echo -n))

	#if [[ $isDaemonRunning != "pong" ]]; then
	#	eww -c $ewwPath daemon
	#fi

	if [ ! -f $tmpFile ]; then
		isOpenYet=$(${eww} -c $ewwPath windows | grep '*' | tr -d "*")
		if [[ $isOpenYet == $windows ]]; then
			exit
		fi
		touch $tmpFile
		${eww} -c $ewwPath open $windows
		${eww} -c $ewwPath update SHOW_WIDGET=true
	else
		rm $tmpFile
		${eww} -c $ewwPath update SHOW_WIDGET=false
		sleep 0.2
		${eww} -c $ewwPath close $windows
	fi
}

toggle
