#!/bin/bash

notify() {
    notify-send "WiFi" "$1"
}

wifi_status=$(nmcli radio wifi)

if [[ "$wifi_status" == "disabled" ]]; then
    choice=$(printf "睊  Enable WiFi" | wofi --dmenu -p "WiFi" -i -k /dev/null)
    [[ -n "$choice" ]] && nmcli radio wifi on && notify "WiFi turned on"
    exit 0
fi

nmcli device wifi rescan &>/dev/null &

current_ssid=$(nmcli -t -f ACTIVE,SSID device wifi list | grep "^yes" | cut -d: -f2)
current_signal=$(nmcli -t -f ACTIVE,SIGNAL device wifi list | grep "^yes" | cut -d: -f2)

menu="睊  Disable WiFi\n"

if [[ -n "$current_ssid" ]]; then
    menu+="󰖟  Connected: $current_ssid ($current_signal%)\n"
else
    menu+="󰖟  Not connected\n"
fi

menu+="---\n"

while IFS=: read -r active ssid security signal; do
    [[ -z "$ssid" || "$ssid" == "SSID" ]] && continue
    [[ "$active" == "yes" ]] && continue

    if [[ -z "$security" ]]; then
        icon=""
        tag=""
    else
        icon=""
        tag=""
    fi

    menu+="$icon  $ssid  ($tag, $signal%)\n"
done < <(nmcli -t -f ACTIVE,SSID,SECURITY,SIGNAL device wifi list | sort -t: -k4 -rn)

choice=$(echo -e "$menu" | wofi --dmenu -p "WiFi" -i -k /dev/null)
[[ -z "$choice" ]] && exit 0

if [[ "$choice" == "睊  Disable WiFi" ]]; then
    nmcli radio wifi off
    notify "WiFi turned off"
    exit 0
fi

ssid=$(echo "$choice" | sed 's/^[^ ]*  //' | sed 's/  (.*)//' | sed 's/[[:space:]]*$//')
[[ -z "$ssid" ]] && exit 0

if echo "$choice" | grep -q ""; then
    password=$(wofi --dmenu -p "Password for $ssid" --password)
    if [[ -n "$password" ]]; then
        result=$(nmcli device wifi connect "$ssid" password "$password" 2>&1)
        if [[ $? -eq 0 ]]; then
            notify "Connected to $ssid"
        else
            notify "Failed: $result"
        fi
    fi
else
    result=$(nmcli device wifi connect "$ssid" 2>&1)
    if [[ $? -eq 0 ]]; then
        notify "Connected to $ssid"
    else
        notify "Failed: $result"
    fi
fi
