#!/bin/bash
# Path to the ghostty config file
CONFIG_FILE="$HOME/.config/ghostty/config"

# Check if the file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found!"
  exit 1
fi

# Extract the current background-opacity value
current_opacity=$(grep -E '^[[:space:]]*background-opacity[[:space:]]*=' "$CONFIG_FILE" | awk -F '=' '{print $2}' | tr -d '[:space:]')

echo "Current background-opacity is $current_opacity"

# Determine the new opacity value
if [ "$current_opacity" == "1.0" ]; then
  new_opacity="0.65"
else
  new_opacity="1.0"
fi

# Replace the current background-opacity value with the new value in the config file
sed -i.bak -E "s/^[[:space:]]*background-opacity[[:space:]]*=[[:space:]]*${current_opacity}/background-opacity = ${new_opacity}/" "$CONFIG_FILE"

echo "Background-opacity has been set to $new_opacity"
