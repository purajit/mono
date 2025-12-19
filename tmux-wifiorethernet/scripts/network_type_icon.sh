#!/usr/bin/env bash

interface=$(route -n get 0.0.0.0 | grep '^ *interface: ' | awk '{print $2}')
ethernet_or_wifi=$(networksetup -listallhardwareports | grep -B1 "$interface" | grep '^Hardware Port: ' | awk '{print $3}')

icon_wifi=$(tmux show-option -gqv "@internet_icon_wifi")
icon_ethernet=$(tmux show-option -gqv "@internet_icon_ethernet")

if [[ "$ethernet_or_wifi" = "Wi-Fi" ]]; then
    echo "$icon_wifi"
else
    echo "$icon_ethernet"
fi
