#!/bin/bash

# Check if argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <wallpaper_path>"
  exit 1
fi

# Configuration variables
force_generate=0
generatedversions="$HOME/.config/hypr/cache/wal"
waypaperrunning="$HOME/.config/hypr/cache/waypaper-running"
blurredwallpaper="$HOME/.config/hypr/cache/wal/blurred_wal.png"
squarewallpaper="$HOME/.config/hypr/cache/wal/square_wal.png"
blurfile="$HOME/.config/hypr/settings/blur.sh"

# Get target wallpaper from argument
used_wallpaper="$1"

# Verify if the wallpaper file exists
if [ ! -f "$used_wallpaper" ]; then
  echo "Error: Wallpaper file '$used_wallpaper' does not exist"
  exit 1
fi

# Get the blur amount from blur file, default to "50x30" if not found
if [ -f "$blurfile" ]; then
  blur=$(cat "$blurfile")
else
  blur="50x30"
fi

# Get wallpaper filename for cache
wallpaperfilename=$(basename "$used_wallpaper")

# Create cache directory if it doesn't exist
mkdir -p "$generatedversions"

# Clean up existing cached files
echo ":: Cleaning up existing cached files"
if [ -f "$blurredwallpaper" ]; then
  rm "$blurredwallpaper"
  echo ":: Removed existing blurred wallpaper"
fi

if [ -f "$squarewallpaper" ]; then
  rm "$squarewallpaper"
  echo ":: Removed existing square wallpaper"
fi

if [ -f "$generatedversions/blur-$blur-$wallpaperfilename.png" ]; then
  rm "$generatedversions/blur-$blur-$wallpaperfilename.png"
  echo ":: Removed existing cached blur version"
fi

if [ -f "$generatedversions/square-$wallpaperfilename.png" ]; then
  rm "$generatedversions/square-$wallpaperfilename.png"
  echo ":: Removed existing cached square version"
fi

# Generate square wallpaper
echo ":: Generate new cached wallpaper square-$wallpaperfilename"
magick "$used_wallpaper" -gravity Center -extent 1:1 "$squarewallpaper"
cp "$squarewallpaper" "$generatedversions/square-$wallpaperfilename.png"
echo ":: Square version generated"

# Generate blurred wallpaper
echo ":: Generate new cached wallpaper blur-$blur-$wallpaperfilename with blur $blur"
dunstify "Generate new blurred version" "with blur $blur" -h int:value:66 -h string:x-dunst-stack-tag:wallpaper

# Resize and blur
magick "$used_wallpaper" -resize 75% "$blurredwallpaper"
echo ":: Resized to 75%"

if [ ! "$blur" == "0x0" ]; then
  magick "$blurredwallpaper" -blur "$blur" "$blurredwallpaper"
  cp "$blurredwallpaper" "$generatedversions/blur-$blur-$wallpaperfilename.png"
  echo ":: Blurred"
fi

# Copy the final versions to the cache
if [ -f "$generatedversions/blur-$blur-$wallpaperfilename.png" ]; then
  cp "$generatedversions/blur-$blur-$wallpaperfilename.png" "$blurredwallpaper"
  echo ":: Blurred version copied to $blurredwallpaper"
fi

if [ -f "$generatedversions/square-$wallpaperfilename.png" ]; then
  echo ":: Square version copied to $squarewallpaper"
fi
