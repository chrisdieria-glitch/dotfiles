#!/bin/bash

wifi_status=$(nmcli radio wifi)
if [[ "$wifi_status" == "enabled" ]]; then
    ssid=$(nmcli -t -f ACTIVE,SSID device wifi list | grep "^yes" | cut -d: -f2)
    signal=$(nmcli -t -f ACTIVE,SIGNAL device wifi list | grep "^yes" | cut -d: -f2)
    if [[ -n "$ssid" ]]; then
        wifi_line="  WiFi: ON  [$ssid $signal%]"
    else
        wifi_line="  WiFi: ON  [No connection]"
    fi
else
    wifi_line="  WiFi: OFF"
fi

bt_powered=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
if [[ "$bt_powered" == "yes" ]]; then
    connected=$(bluetoothctl devices Connected | head -1 | grep -oP 'Device \K(\S+)')
    if [[ -n "$connected" ]]; then
        bt_name=$(bluetoothctl info "$connected" | grep "Name:" | cut -d: -f2- | sed 's/^ //')
        bt_line="  Bluetooth: ON  [$bt_name]"
    else
        bt_line="  Bluetooth: ON"
    fi
else
    bt_line="  Bluetooth: OFF"
fi

audio_sink=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
vol_pct=$(echo "$audio_sink" | awk '{printf "%.0f", $2 * 100}')
muted=$(echo "$audio_sink" | grep -c "MUTED")
if [[ "$muted" -gt 0 ]]; then
    vol_line="  Volume: MUTED"
else
    filled=$(( vol_pct / 10 ))
    bar=$(printf "█%.0s" $(seq 1 $filled) 2>/dev/null)
    space=$(printf " %.0s" $(seq 1 $((10 - filled))) 2>/dev/null)
    vol_line="  Volume: $bar$space $vol_pct%"
fi

if command -v brightnessctl &>/dev/null; then
    brightness=$(brightnessctl get)
    max=$(brightnessctl max)
    br_pct=$(( brightness * 100 / max ))
    filled=$(( br_pct / 10 ))
    bar=$(printf "█%.0s" $(seq 1 $filled) 2>/dev/null)
    space=$(printf " %.0s" $(seq 1 $((10 - filled))) 2>/dev/null)
    br_line="☀️  Brightness: $bar$space $br_pct%"
else
    br_line="☀️  Brightness: [?] install brightnessctl"
fi

menu=""
menu+="  WiFi | $wifi_line\n"
menu+="  BT   | $bt_line\n"
menu+="  Vol  | $vol_line\n"
menu+="☀️  Brgt | $br_line\n"
menu+="---\n"
menu+="  Open WiFi settings\n"
menu+="  Open Bluetooth settings\n"
menu+="  Open Audio settings\n"
menu+="☀️  Open Brightness controls\n"
menu+="---\n"
menu+="󰐥  Power Menu"

choice=$(echo -e "$menu" | wofi --dmenu -p "Quick Settings" -i -k /dev/null)
[[ -z "$choice" ]] && exit 0

case "$choice" in
    "  Open WiFi settings")
        exec ~/.config/hypr/scripts/wifi-menu.sh
        ;;
    "  Open Bluetooth settings")
        exec ~/.config/hypr/scripts/bt-menu.sh
        ;;
    "  Open Audio settings")
        exec pavucontrol
        ;;
    "☀️  Open Brightness controls")
        exec ~/.config/hypr/scripts/brightness-menu.sh
        ;;
    "󰐥  Power Menu")
        exec ~/.config/hypr/scripts/power.sh
        ;;
esac
