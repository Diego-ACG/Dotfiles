#!/bin/bash

Status=$(mpc | sed -n 2p | awk '{print $1}' | sed 's/]//g;s/\[//g')

if [[ $Status = playing ]]; then
	mpc prev;
	notify-send "`mpc current`" --icon=~/.fvwm/icons/onda.png
elif [[ $Status = paused ]]; then
	notify-send "Press Play" --icon=~/.fvwm/icons/pare.png
fi