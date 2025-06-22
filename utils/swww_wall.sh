#!/bin/sh

#load $WALLPAPER_IMAGE environment variable
#source $HOME/.config/hypr/scripts/variables/load_envs

$BACKGROUND_IMAGE=$(find ~/Pictures/wallpapers -type f -name '*.gif' | shuf -n1)

function load_wp(){
    swww img -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration .8 --transition-step 255 --transition-fps 60  $(find ~/Pictures/wallpapers -type f -name '*.gif' | shuf -n1)
}

#perform cleanup and exit
if ! swww query; then
    swww init
fi

load_wp
