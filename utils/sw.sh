#!/usr/bin/env bash
# rofi -show window for Hyprland, basically

set -x
state="$(hyprctl -j clients)"
active_window="$(hyprctl -j activewindow)"
current_addr="$(echo "$active_window" | gojq -r '.address')"

window="$(echo "$state" |
    gojq -r '.[] | select(.monitor != -1 ) | "\(.address)    \(.workspace.name)    \(.title)"' |
    sed "s|$current_addr|focused ->|" |
    sort -r |
    rofi -dmenu -p "App:" -i -markup-rows -no-fixed-num-lines -theme-str 'window { width: 20%; }'

addr="$(echo "$window" | awk '{print $1}')"
ws="$(echo "$window" | awk '{print $2}')"

if [[ "$addr" =~ focused* ]]; then
    echo 'already focused, exiting'
    exit 0
fi

fullscreen_on_same_ws="$(echo "$state" | gojq -r ".[] | select(.fullscreen == true) | select(.workspace.name == \"$ws\") | .address")"

if [[ "$window" != "" ]]; then
    if [[ "$fullscreen_on_same_ws" == "" ]]; then
        hyprctl dispatch focuswindow address:${addr}
    else
        # If we want to focus app_A and app_B is fullscreen on the same workspace,
        # app_A will get focus, but app_B will remain on top.
        # This monstrosity is to make sure app_A will end up on top instead.
        # XXX: doesn't handle fullscreen 0, but I don't care.
        notify-send 'Complex switch' "$window"
        hyprctl --batch "dispatch focuswindow address:${fullscreen_on_same_ws}; dispatch fullscreen 1; dispatch focuswindow address:${addr}; dispatch fullscreen 1"
    fi
fi

