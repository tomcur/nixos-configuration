#!/usr/bin/env bash

# Call this script as:
# $./volume-control.sh up
# $./volume-control.sh down
# $./volume-control.sh toggle-mute

step_size=5

notify() {
    # Bar code from https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a
    if [ "$1" == "mute" ]; then
        icon="audio-volume-muted"
        message=""
    else
        icon="audio-volume-high"
	bar_size=20
	pre_bar=$(($1 * $bar_size / 100))
	post_bar=$(($bar_size - $pre_bar))
        pre_bar_str="$(seq -s "─" 0 $pre_bar | sed 's/[0-9]//g')"
        post_bar_str="$(seq -s "─" 0 $post_bar | sed 's/[0-9]//g')"
        message="${pre_bar_str}|${post_bar_str}"
    fi

    gdbus call \
        --session \
        --dest org.freedesktop.Notifications \
        --object-path /org/freedesktop/Notifications \
        --method org.freedesktop.Notifications.Notify -- \
        "Volume" 28593163 "${icon}" "${message}" \
        "" [] "{\"urgency\": <byte 0>}" -1
}

case $1 in
    up)
        volume=$(pamixer --increase ${step_size} --unmute --get-volume)
        notify $volume
        ;;
    down)
        volume=$(pamixer --decrease ${step_size} --get-volume)
        notify $volume
        ;;
    toggle-mute)
        state=($(pamixer --toggle-mute --get-mute --get-volume))
        mute=${state[0]}
        volume=${state[1]}

        if [ "$mute" = "true" ]; then
            notify mute
        else
            notify $volume
        fi
esac
