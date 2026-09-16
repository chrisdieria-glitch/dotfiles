#!/bin/bash

WAYBAR_CONFIG="$HOME/.config/waybar"

while inotifywait -q -r \
    -e modify,create,delete,move \
    --exclude '.*\.swp$|.*~$|.*\.tmp$' \
    "$WAYBAR_CONFIG"; do

    pkill -x waybar
    sleep 0.2
    waybar &
done
