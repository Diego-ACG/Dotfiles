#!/usr/bin/env bash

# Audio volume changer using alsa mixer

function cvol {
    amixer -D pulse get Master | grep '%' | head -n 1 | awk -F'[' '{print $2}' | awk -F'%' '{print $1}'
}

function chkmute {
    amixer -D pulse get Master | grep '%' | grep -oE '[^ ]+$' | grep off
}

function notify {
    volume=`cvol`
    
    if [ "$volume" = "0" ]; then
        icon_name="notification-audio-volume-muted"
    else    
        if [  "$volume" -lt "10" ]; then
            icon_name="notification-audio-volume-low"
        else
            if [ "$volume" -lt "30" ]; then
                icon_name="notification-audio-volume-low"
            else
                if [ "$volume" -lt "70" ]; then
                    icon_name="notification-audio-volume-medium"
                else
                    icon_name="notification-audio-volume-high"
                fi
            fi
        fi
    fi

    ~/.fvwm/scripts/notify-send.sh -i "$icon_name" -t 2000 -r 123 "Media Volume" "On level $volume%"
}

case $1 in
    up)
	# Unmute
	amixer -D pulse set Master on > /dev/null
	# +5%
	amixer -D pulse sset Master 5%+ > /dev/null
	notify
	;;
    down)
    # Unmute
	amixer -D pulse set Master on > /dev/null
    # -5%
	amixer -D pulse sset Master 5%- > /dev/null
	notify
	;;
    mute)
    # Toggle mute
	amixer -D pulse set Master 1+ toggle > /dev/null
	if chkmute ; then
    icon_name="notification-audio-volume-muted"
    ~/.fvwm/scripts/notify/notify-send.sh -i "$icon_name" -t 2000 -r 123 "Media Volume" "Muted"
	else
	    notify
	fi
	;;
esac    