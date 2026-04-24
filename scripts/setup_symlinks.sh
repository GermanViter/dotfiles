#!/bin/bash

# setup_symlinks.sh - Automate symlinking of dotfiles to ~/.config and ~/

# Get the absolute path of the dotfiles directory (parent of the scripts folder)
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
CONFIG_DIR="$HOME/.config"

# Ensure ~/.config exists
mkdir -p "$CONFIG_DIR"

echo "Starting symlink setup from $DOTFILES_DIR"

# Iterate over all directories in the dotfiles folder
for app_dir in "$DOTFILES_DIR"/*/; do
    # Remove trailing slash and get the folder name
    app_dir=${app_dir%/}
    app_name=$(basename "$app_dir")

    # Skip the scripts directory and any hidden directories (like .git)
    if [[ "$app_name" == "scripts" || "$app_name" == "gemini" || "$app_name" == .* ]]; then
        continue
    fi

    echo "Processing: $app_name"

    # 1. Handle contents of the .config directory within each app folder
    if [ -d "$app_dir/.config" ]; then
        for item in "$app_dir/.config"/*; do
            # Skip if the glob didn't match anything
            [ -e "$item" ] || continue
            
            target_name=$(basename "$item")
            target_path="$CONFIG_DIR/$target_name"
            
            echo "  Linking ~/.config/$target_name -> $item"
            # -s: symbolic, -f: force (overwrite existing), -n: treat link to directory as a file
            ln -sfn "$item" "$target_path"
        done
        
        # Also check for hidden files inside .config (e.g., .config/.something)
        for item in "$app_dir/.config"/.*; do
            basename_item=$(basename "$item")
            if [[ "$basename_item" == "." || "$basename_item" == ".." ]]; then
                continue
            fi
            [ -e "$item" ] || continue
            
            target_path="$CONFIG_DIR/$basename_item"
            echo "  Linking ~/.config/$basename_item -> $item"
            ln -sfn "$item" "$target_path"
        done
    fi

    # 2. Handle top-level dotfiles within each app folder (e.g., .zshrc, .tmux.conf)
    # This links anything starting with a dot in the app folder to the home directory,
    # EXCEPT for the .config directory which we handled above.
    for item in "$app_dir"/.*; do
        basename_item=$(basename "$item")
        
        # Skip current dir, parent dir, and .config
        if [[ "$basename_item" == "." || "$basename_item" == ".." || "$basename_item" == ".config" ]]; then
            continue
        fi
        
        [ -e "$item" ] || continue
        
        target_path="$HOME/$basename_item"
        echo "  Linking ~/$basename_item -> $item"
        ln -sfn "$item" "$target_path"
    done
done

echo "Symlink setup complete!"
