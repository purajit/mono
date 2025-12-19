#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

network_icon_interpolation="\#{network_type_icon}"
network_icon_command="#($CURRENT_DIR/scripts/network_type_icon.sh)"

do_interpolation() {
    local all_interpolated="$1"
    all_interpolated=${all_interpolated//$network_icon_interpolation/$network_icon_command}
    echo "$all_interpolated"
}

function update_tmux_option {
    local option="$1"
    local option_value="$(tmux show-option -gqv "$option")"
    local new_option_value="$(do_interpolation "$option_value")"
    tmux set-option -gq "$option" "$new_option_value"
}

function main {
    update_tmux_option "status-right"
    update_tmux_option "status-left"
}

main
