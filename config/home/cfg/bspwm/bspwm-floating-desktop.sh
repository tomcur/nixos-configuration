#!/usr/bin/env bash

bspc subscribe node | while read -a msg ; do
  FLOATING_DESKTOP_ID=$(bspc query -D -d '10')
  desk_id=${msg[2]}
  wid=${msg[3]}
  [ "$FLOATING_DESKTOP_ID" = "$desk_id" ] && bspc node "$wid" -t floating
done
