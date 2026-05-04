#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/.dotfiles/assets/wallpapers/swww/"

# Get a random wallpaper from the directory
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Check if swww-daemon or awww-daemon is running, if not start it
if ! pgrep -x "swww-daemon" >/dev/null && ! pgrep -x "awww-daemon" >/dev/null; then
    swww-daemon
fi

# Set the wallpaper with an animation
swww img "$WALLPAPER" \
    --transition-type wipe \
    --transition-fps 180

echo "Wallpaper set to: $WALLPAPER"
