# Dotfiles

Personal configuration files and environment settings for macOS and Linux. 
> Some apps work better with MacOs like AeroSpace, Karabiner and Raycast so if you are on Linux, just delete those folders before running the script. The rest of the configs should work fine on both platforms.

## Contents
- [Overview](#overview)
- [Screenshots](#screenshots)
- [Managed Applications](#managed-applications)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Script Options](#script-options)
- [How it Works](#how-it-works)
- [Troubleshooting](#troubleshooting)
- [Adding New Configs](#adding-new-configs)

## Overview

This repository uses a modular structure where each directory represents an application or tool. A central setup script manages the creation of symbolic links from the repository to your home directory and `~/.config` folder, and handles system dependencies via Homebrew.

## Screenshots

<p align="center">
  <img src="assets/fastfetch.png" width="400" />
  <img src="assets/neovim.png" width="400" />
  <img src="assets/yazi.png" width="400" />
  <img src="assets/cyber-girl.png" width="400" />
</p>

## Managed Applications

- **Terminal/Shell**: [Fish](https://fishshell.com/), [Zsh](https://www.zsh.org/), [Tmux](https://github.com/tmux/tmux)
- **Editors**: [Neovim](https://neovim.io/) (LazyVim), [Zed](https://zed.dev/)
- **Prompt**: [Starship](https://starship.rs/)
- **UI/Window Management**: [Aerospace](https://github.com/nikitabobko/AeroSpace), [Ghostty](https://ghostty.org/), [Kitty](https://sw.kovidgoyal.net/kitty/), [Karabiner](https://karabiner-elements.pqrs.org/)
- **CLI Tools**: [Fastfetch](https://github.com/fastfetch-cli/fastfetch), [Bat](https://github.com/sharkdp/bat), [Yazi](https://github.com/sxyazi/yazi), [Neofetch](https://github.com/dylanaraps/neofetch)
- **Package Management**: [Homebrew](https://brew.sh/) (via Brewfile)
- **Others**: Raycast, Macmon, Envman, JGit

## Dependencies
- Homebrew (for package management)
- Git (for cloning the repository)
- Zsh (for shell configurations)

## Installation

To apply these configurations to a new system:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
   ```

2. **Run the setup script:**
   The script can be run from any directory and supports several options:
   ```bash
   ~/.dotfiles/scripts/setup_symlinks.sh --brew
   ```

### Script Options

- `(no arguments)`: Creates symlinks and backs up existing files.
- `--brew`: Installs all packages listed in the `Brewfile` using Homebrew.
- `--dry-run`: Simulates the process without making any changes.
- `--unlink`: Removes the symlinks and restores backups if available.
- `--help`: Displays help information.

## How it Works

The `scripts/setup_symlinks.sh` script is designed to be portable and robust:

1. **Location Agnostic**: It automatically finds the root of the dotfiles repository.
2. **Automatic Backups**: If a real file or directory exists where a symlink should be, it is backed up to `~/.dotfiles_backup/` before being replaced.
3. **Smart Linking**:
   - **`.config` folders**: Links contents of `app/.config/` into `~/.config/`.
   - **Top-level dotfiles**: Links hidden files (e.g., `.zshrc`) into `~/`.
   - **Special files**: Symlinks the root `Brewfile` to `~/.Brewfile`.
4. **Homebrew Integration**: The `--brew` flag uses `brew bundle` to install all taps, brews, and casks defined in the `Brewfile`.
5. **Logging**: Uses color-coded output to clearly show what was linked, skipped, or backed up.
6. **Idempotency**: Safe to run multiple times; it will skip already correct links.

## Troubleshooting
- If you encounter issues with symlinks, check the backup directory for any files that were moved.
- Ensure you have Homebrew installed if you plan to use the `--brew` option.
- For any application-specific issues, refer to the respective application's documentation or open an issue in this repository.

## Adding New Configs

To add a new application to this repo:
1. Create a folder named after the application.
2. If the config goes in `~/.config`, create a `.config` folder inside your new folder and put the config there.
3. If the config goes in `~/` (like `.bashrc`), put it in the root of the new folder.
4. Run `./scripts/setup_symlinks.sh` to apply the changes.
