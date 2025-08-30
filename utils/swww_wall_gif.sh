#!/bin/bash

# Define constants
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
WALLPAPER_NAME="frog_study.gif"

# Function to initialize swww if not running
init_swww() {
  if ! swww query; then
    swww-daemon &
    sleep 0.1
  fi
}

# Function to set wallpaper
set_wallpaper() {
  local wallpaper
  wallpaper=$(find "$WALLPAPER_DIR" -type f -name "*.gif" | shuf -n1)

  if [[ -z "$wallpaper" ]]; then
    echo "Error: Wallpaper not found" >&2
    exit 1
  fi

  echo "Setting wallpaper: $wallpaper"

  sleep 2

  swww img "$wallpaper" \
    -t any \
    --transition-bezier 0.0,0.0,1.0,1.0 \
    --transition-duration .8 \
    --transition-step 255 \
    --transition-fps 60
}

# Main execution
main() {
  init_swww &
  # swww-daemon &
  # sleep 0.1 &
  set_wallpaper
}

main
