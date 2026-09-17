#!/bin/bash

MAX_LENGTH=35
SCROLL_SPEED=0.15

while true; do
    title=$(hyprctl activewindow -j | jq -r '.title')

    if [ "$title" = "null" ] || [ -z "$title" ]; then
        echo '{"text": ""}'
        sleep 0.5
        continue
    fi

    # Si el título cabe, mostrarlo normal
    if [ ${#title} -le $MAX_LENGTH ]; then
        echo "{\"text\":\"$title\"}"
        sleep 0.5
        continue
    fi

    # Añadir espacios para separar el final del principio
    text="$title     "

    # Desplazar el texto
    for ((i=0; i<${#text}; i++)); do
        output="${text:i}${text:0:i}"

        # Escapar caracteres especiales para JSON
        output=$(printf '%s' "$output" | sed 's/\\/\\\\/g; s/"/\\"/g')

        echo "{\"text\":\"${output:0:$MAX_LENGTH}\"}"

        sleep $SCROLL_SPEED
    done
done
