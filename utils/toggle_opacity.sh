#!/bin/bash

# Path to the alacritty.toml file
CONFIG_FILE="$HOME/.config/alacritty/alacritty.toml"

# Check if the file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found!"
  exit 1
fi

# Extract the current opacity value
current_opacity=$(grep -E '^[[:space:]]*opacity[[:space:]]*=' "$CONFIG_FILE" | awk -F '=' '{print $2}' | tr -d '[:space:]')

echo "Current opacity is $current_opacity"

# Determine the new opacity value
if [ "$current_opacity" == "1.0" ]; then
  #  new_opacity="0.75"
  new_opacity="0.65"
else
  new_opacity="1.0"
fi
# Replace the current opacity value with the new value in the config file
sed -i.bak -E "s/^[[:space:]]*opacity[[:space:]]*=[[:space:]]*${current_opacity}/opacity = ${new_opacity}/" "$CONFIG_FILE"
#alacritty msg config window.opacity="$new_opacity"

echo "Opacity has been set to $new_opacity"
