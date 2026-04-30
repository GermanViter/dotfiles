#!/bin/bash

# Themes:
# 1. main (Rosé Pine)
# 2. moon (Rosé Pine Moon)
# 3. dawn (Rosé Pine Dawn)

THEME=$1

if [[ -z "$THEME" ]]; then
    echo "Usage: switch-theme.sh [main|moon|dawn]"
    exit 1
fi

# Use the DOTFILES environment variable if set, otherwise default to ~/.dotfiles
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

case $THEME in
main)
    GHOSTTY_THEME="rose pine"
    KITTY_THEME="Rosé Pine"
    NVIM_VARIANT="main"
    WALLPAPER="cyber_girl.jpg"
    ;;
moon)
    GHOSTTY_THEME="rose pine moon"
    KITTY_THEME="Rosé Pine Moon"
    NVIM_VARIANT="moon"
    WALLPAPER="cyber_girl.jpg"
    ;;
catppuccin)
    GHOSTTY_THEME="catppuccin mocha"
    KITTY_THEME="Catppuccin-Mocha"
    NVIM_VARIANT="catppuccin"
    WALLPAPER="cyber_girl.jpg"
    ;;
dawn)
    GHOSTTY_THEME="rose pine dawn"
    KITTY_THEME="Rosé Pine Dawn"
    NVIM_VARIANT="dawn"
    WALLPAPER="cyber_girl.jpg"
    ;;
*)
    echo "Unknown theme: $THEME"
    exit 1
    ;;
esac

echo "Switching to $THEME..."

# Update Ghostty
# Ghostty reloads automatically when its config file is saved
if [ -f "$DOTFILES/ghostty/.config/ghostty/config" ]; then
    sed -i '' "s/^theme = .*/theme = $GHOSTTY_THEME/" "$DOTFILES/ghostty/.config/ghostty/config"
    echo "✓ Ghostty updated"
else
    echo "✗ Ghostty config not found at $DOTFILES/ghostty/.config/ghostty/config"
fi

# Update Kitty
# kitty +kitten themes updates current-theme.conf and reloads kitty
if command -v kitty >/dev/null 2>&1; then
    kitty +kitten themes --reload-in=all "$KITTY_THEME"
    echo "✓ Kitty updated"
else
    echo "! Kitty command not found, skipping kitty update"
fi

# Update Neovim variant
# This file is required in lua/plugins/colorscheme.lua
mkdir -p "$DOTFILES/nvim/.config/nvim/lua/config"
echo "return \"$NVIM_VARIANT\"" >"$DOTFILES/nvim/.config/nvim/lua/config/theme_variant.lua"
echo "✓ Neovim variant updated"

# Update Wallpaper
# Use AppleScript to change wallpaper on macOS
WALLPAPER_PATH="$DOTFILES/assets/wallpapers/$WALLPAPER"
if [ -f "$WALLPAPER_PATH" ]; then
    # Convert path to absolute if it's relative
    [[ "$WALLPAPER_PATH" = /* ]] || WALLPAPER_PATH="$PWD/$WALLPAPER_PATH"
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER_PATH\""
    echo "✓ Wallpaper updated"
else
    echo "✗ Wallpaper not found at $WALLPAPER_PATH"
fi

# Update Starship
# Symlink the correct config file to ~/.config/starship.toml
STARSHIP_TARGET="$HOME/.config/starship.toml"
if [ "$THEME" = "catppuccin" ]; then
    ln -sf "$DOTFILES/starship/.config/catppuccin.toml" "$STARSHIP_TARGET"
    echo "✓ Starship updated (Catppuccin)"
else
    ln -sf "$DOTFILES/starship/.config/starship.toml" "$STARSHIP_TARGET"
    echo "✓ Starship updated (Standard)"
fi

echo "Successfully switched theme to $THEME"
