#!/bin/bash

# Themes:
# 1. main (Rosé Pine)
# 2. moon (Rosé Pine Moon)
# 3. dawn (Rosé Pine Dawn)
# 4. catppuccin (Catppuccin Mocha)
# 5. black (Black Metal Gorgoroth)

THEME=$1

if [[ -z "$THEME" ]]; then
    echo "Usage: switch-theme.sh [main|moon|dawn|catppuccin|black|gruvbox]"
    exit 1
fi

# Use the DOTFILES environment variable if set, otherwise default to ~/.dotfiles
# Use realpath to ensure we have an absolute path
DOTFILES_DIR="${DOTFILES:-$HOME/.dotfiles}"
DOTFILES=$(cd "$DOTFILES_DIR" && pwd)

case $THEME in
main)
    GHOSTTY_THEME="rose pine"
    KITTY_THEME="Rosé Pine"
    NVIM_VARIANT="main"
    WALLPAPER="cyber_girl.jpg"
    YAZI_THEME="theme-rose-pine.toml"
    ;;
moon)
    GHOSTTY_THEME="rose pine moon"
    KITTY_THEME="Rosé Pine Moon"
    NVIM_VARIANT="moon"
    WALLPAPER="cyber_girl.jpg"
    YAZI_THEME="theme-rose-pine.toml"
    ;;
catppuccin)
    GHOSTTY_THEME="catppuccin mocha"
    KITTY_THEME="Catppuccin-Mocha"
    NVIM_VARIANT="catppuccin"
    WALLPAPER="1-totoro.png"
    YAZI_THEME="theme-catppuccin.toml"
    ;;
dawn)
    GHOSTTY_THEME="rose pine dawn"
    KITTY_THEME="Rosé Pine Dawn"
    NVIM_VARIANT="dawn"
    WALLPAPER="cyber_girl.jpg"
    YAZI_THEME="theme-rose-pine.toml"
    ;;
black)
    GHOSTTY_THEME="Black Metal (Gorgoroth)"
    KITTY_THEME="Black Metal"
    NVIM_VARIANT="black"
    WALLPAPER="1-dark-waters.jpg"
    YAZI_THEME="theme-black.toml"
    ;;
gruvbox)
    YAZI_THEME="theme-gruvbox.toml"
    GHOSTTY_THEME="Gruvbox Dark"
    KITTY_THEME="Gruvbox Dark"
    NVIM_VARIANT="gruvbox"
    WALLPAPER="1-tree-tops.jpg"
    ;;
*)
    echo "Unknown theme: $THEME"
    exit 1
    ;;
esac

echo "Switching to $THEME..."

# Update Ghostty
if [ -f "$DOTFILES/ghostty/.config/ghostty/config" ]; then
    sed -i '' "s/^theme = .*/theme = $GHOSTTY_THEME/" "$DOTFILES/ghostty/.config/ghostty/config"
    echo "✓ Ghostty updated"
else
    echo "✗ Ghostty config not found at $DOTFILES/ghostty/.config/ghostty/config"
fi

# Update Kitty
if command -v kitty >/dev/null 2>&1; then
    kitty +kitten themes --reload-in=all "$KITTY_THEME"
    echo "✓ Kitty updated"
else
    echo "! Kitty command not found, skipping kitty update"
fi

# Update Neovim variant
mkdir -p "$DOTFILES/nvim/.config/nvim/lua/config"
echo "return \"$NVIM_VARIANT\"" >"$DOTFILES/nvim/.config/nvim/lua/config/theme_variant.lua"
echo "✓ Neovim variant updated"

# Update Wallpaper
WALLPAPER_PATH="$DOTFILES/assets/wallpapers/$WALLPAPER"
if [ -f "$WALLPAPER_PATH" ]; then
    if [ "$(uname)" = "Darwin" ]; then
        # macOS requires absolute POSIX paths for AppleScript to work reliably
        osascript -e "tell application \"System Events\" to tell every desktop to set picture to POSIX file \"$WALLPAPER_PATH\""
    elif [ "$(uname)" = "Linux" ]; then
        # Check for common Linux wallpaper tools
        if command -v feh >/dev/null 2>&1; then
            feh --bg-fill "$WALLPAPER_PATH"
        elif command -v swww >/dev/null 2>&1; then
            swww img "$WALLPAPER_PATH"
        elif command -v gsettings >/dev/null 2>&1; then
            # GNOME fallback
            gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_PATH"
            gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_PATH"
        else
            echo "! No supported wallpaper tool found (feh/swww/gsettings)"
        fi
    fi
    echo "✓ Wallpaper updated"
else
    echo "✗ Wallpaper not found at $WALLPAPER_PATH"
fi

# Update Starship
STARSHIP_TARGET="$HOME/.config/starship.toml"
if [ "$THEME" = "catppuccin" ]; then
    ln -sf "$DOTFILES/starship/.config/catppuccin.toml" "$STARSHIP_TARGET"
    echo "✓ Starship updated (Catppuccin)"
else
    ln -sf "$DOTFILES/starship/.config/starship.toml" "$STARSHIP_TARGET"
    echo "✓ Starship updated (Standard)"
fi

# Update Yazi
# Symlink the correct theme file to ~/.config/yazi/theme.toml
YAZI_TARGET="$HOME/.config/yazi/theme.toml"
if [ -f "$DOTFILES/yazi/.config/yazi/$YAZI_THEME" ]; then
    ln -sf "$DOTFILES/yazi/.config/yazi/$YAZI_THEME" "$YAZI_TARGET"
    echo "✓ Yazi updated ($YAZI_THEME)"
else
    echo "✗ Yazi theme file not found: $YAZI_THEME"
fi

echo "Successfully switched theme to $THEME"
