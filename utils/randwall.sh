#!/bin/bash

PIC=$(find ~/Pictures/wallpapers -type f | shuf -n1)

rm ~/.config/hypr/cache/wal/*

~/.config/hypr/dots/rofi/update_wall_new.sh $PIC
~/bash_utils/create_blur_wal.sh $PIC

wal -i $PIC

swaybg -i $PIC -m fill &

#waypaper --random
