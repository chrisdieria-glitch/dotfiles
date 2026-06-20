#!/bin/bash

if ! command -v brightnessctl &>/dev/null; then
    notify-send "Brightness" "brightnessctl not installed. Run: sudo pacman -S brightnessctl"
    exit 1
fi

device="intel_backlight"
current=$(brightnessctl -d "$device" get)
max=$(brightnessctl -d "$device" max)
current_pct=$(( current * 100 / max ))

menu=""
for pct in 0 10 20 30 40 50 60 70 80 90 100; do
    filled=$(( pct / 10 ))
    bar=$(printf "█%.0s" $(seq 1 $filled))
    if [[ "$pct" -eq "$current_pct" ]]; then
        menu+="  ${bar} ${pct}%\n"
    else
        space=$(printf " %.0s" $(seq 1 $((10 - filled))))
        menu+="   ${bar}${space} ${pct}%\n"
    fi
done

choice=$(echo -e "$menu" | wofi --dmenu -p "Brightness" -i -k /dev/null)
[[ -z "$choice" ]] && exit 0

pct=$(echo "$choice" | grep -oP '\d+(?=%)')
[[ -z "$pct" ]] && exit 0

brightnessctl -d "$device" set "${pct}%"
notify-send "Brightness" "Set to ${pct}%"
