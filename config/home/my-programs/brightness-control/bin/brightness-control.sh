#!/usr/bin/env bash

# Call this script as:
# $./brightness-control.sh up
# $./brightness-control.sh down

step_size=10

notify() {
    # Bar code from https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a
    # icon="audio-volume-high"
    bar_size=20
    pre_bar=$(($1 * $bar_size / 100))
    post_bar=$(($bar_size - $pre_bar))
    pre_bar_str="$(seq -s "─" 0 $pre_bar | sed 's/[0-9]//g')"
    post_bar_str="$(seq -s "─" 0 $post_bar | sed 's/[0-9]//g')"
    message="${pre_bar_str}|${post_bar_str}"

    gdbus call \
        --session \
        --dest org.freedesktop.Notifications \
        --object-path /org/freedesktop/Notifications \
        --method org.freedesktop.Notifications.Notify -- \
        "brightness_control" 28593163 "${icon}" "Brightness" \
        "${message}" [] "{\"urgency\": <byte 0>}" -1
}

floatToInt() {
    printf "%.0f\n" "$1"
}

case $1 in
    up)
        out=$(brightnessctl -m s ${step_size}%+)
        arr=(${out//,/ })
        new_brightness=${arr[3]::-1}
        notify $new_brightness
        ;;
    down)
        out=$(brightnessctl -m s ${step_size}%-)
        arr=(${out//,/ })
        new_brightness=${arr[3]::-1}
        notify $new_brightness
        ;;
esac
