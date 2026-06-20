#!/bin/bash

notify() {
    notify-send "Bluetooth" "$1"
}

bt_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [[ "$bt_status" == "no" ]]; then
    choice=$(printf "  Enable Bluetooth" | wofi --dmenu -p "Bluetooth" -i -k /dev/null)
    [[ -n "$choice" ]] && bluetoothctl power on && notify "Bluetooth turned on"
    exit 0
fi

menu="  Disable Bluetooth\n"

connected_devices=$(bluetoothctl devices Connected | grep -oP 'Device \K(\S+)')
if [[ -n "$connected_devices" ]]; then
    menu+="󰂱  Connected: "
    first=true
    while IFS= read -r mac; do
        name=$(bluetoothctl info "$mac" | grep "Name:" | cut -d: -f2- | sed 's/^ //')
        if [[ "$first" == true ]]; then
            menu+="$name"
            first=false
        else
            menu+=", $name"
        fi
    done <<< "$connected_devices"
    menu+="\n"
fi

menu+="---\n"
menu+="󰂰  Paired devices\n"
menu+="  Scan for new devices\n"

choice=$(echo -e "$menu" | wofi --dmenu -p "Bluetooth" -i -k /dev/null)
[[ -z "$choice" ]] && exit 0

case "$choice" in
    "  Disable Bluetooth")
        bluetoothctl power off
        notify "Bluetooth turned off"
        ;;
    "󰂰  Paired devices")
        devices=$(bluetoothctl paired-devices | grep -oP 'Device \K(\S+) (.*)')
        if [[ -z "$devices" ]]; then
            notify "No paired devices"
            exit 0
        fi

        dev_menu=""
        while IFS= read -r line; do
            mac=$(echo "$line" | awk '{print $1}')
            name=$(echo "$line" | cut -d' ' -f2-)
            if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
                dev_menu+="  $name ($mac)\n"
            else
                dev_menu+="  $name ($mac)\n"
            fi
        done <<< "$devices"

        dev_choice=$(echo -e "$dev_menu" | wofi --dmenu -p "Devices" -i -k /dev/null)
        [[ -z "$dev_choice" ]] && exit 0

        dev_mac=$(echo "$dev_choice" | grep -oP '\(([0-9A-Fa-f:]+)\)' | tr -d '()')
        [[ -z "$dev_mac" ]] && exit 0

        if echo "$dev_choice" | grep -q "^"; then
            bluetoothctl disconnect "$dev_mac"
            notify "Disconnected"
        else
            bluetoothctl connect "$dev_mac" &
            notify "Connecting to $dev_mac..."
        fi
        ;;
    "  Scan for new devices")
        notify "Scanning for 10 seconds..."
        bluetoothctl scan on &
        scan_pid=$!
        sleep 10
        kill "$scan_pid" 2>/dev/null

        new_devices=$(bluetoothctl devices | grep -vFf <(bluetoothctl paired-devices | awk '{print $2}') 2>/dev/null)
        if [[ -z "$new_devices" ]]; then
            notify "No new devices found"
            exit 0
        fi

        scan_menu=""
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            mac=$(echo "$line" | awk '{print $2}')
            name=$(echo "$line" | cut -d' ' -f3-)
            scan_menu+="$name ($mac)\n"
        done <<< "$new_devices"

        scan_choice=$(echo -e "$scan_menu" | wofi --dmenu -p "New devices" -i -k /dev/null)
        [[ -z "$scan_choice" ]] && exit 0

        new_mac=$(echo "$scan_choice" | grep -oP '\(([0-9A-Fa-f:]+)\)' | tr -d '()')
        [[ -z "$new_mac" ]] && exit 0

        bluetoothctl pair "$new_mac" && notify "Paired with $new_mac" || notify "Pairing failed"
        bluetoothctl connect "$new_mac" && notify "Connected to $new_mac" || true
        ;;
esac
