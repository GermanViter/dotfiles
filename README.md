# Dotfiles

Personal configuration files and environment settings for macOS and Linux.

## Overview

This repository uses a modular structure where each directory represents an application or tool. A central setup script manages the creation of symbolic links from the repository to your home directory and `~/.config` folder.

## Managed Applications

- **Terminal/Shell**: [Fish](https://fishshell.com/), [Zsh](https://www.zsh.org/), [Tmux](https://github.com/tmux/tmux)
- **Editors**: [Neovim](https://neovim.io/) (LazyVim), [Zed](https://zed.dev/)
- **Prompt**: [Starship](https://starship.rs/)
- **UI/Window Management**: [Aerospace](https://github.com/nikitabobko/AeroSpace), [Ghostty](https://ghostty.org/), [Kitty](https://sw.kovidgoyal.net/kitty/), [Karabiner](https://karabiner-elements.pqrs.org/)
- **CLI Tools**: [Fastfetch](https://github.com/fastfetch-cli/fastfetch), [Bat](https://github.com/sharkdp/bat), [Yazi](https://github.com/sxyazi/yazi), [Neofetch](https://github.com/dylanaraps/neofetch)
- **Others**: Raycast, Macmon, Envman, JGit

## Installation

To apply these configurations to a new system:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
   ```
2. **If you dont't want git tracking, you can remove the .git directory**
   ```bash
   rm -rf .git
   ```

3. **Run the setup script:**
   ```bash
   cd ~/.dotfiles
   ./scripts/setup_symlinks.sh
   ```

## How it Works

The `scripts/setup_symlinks.sh` script automates the configuration by:

1. **Mapping `.config` subfolders**: For any app folder containing a `.config/` directory, the script symlinks the contents into `~/.config/`.
   - *Example*: `fastfetch/.config/fastfetch` -> `~/.config/fastfetch`
2. **Mapping top-level dotfiles**: Any hidden file (starting with `.`) in an app's root folder is symlinked directly to your home directory.
   - *Example*: `zsh/.zshrc` -> `~/.zshrc`

The script is **idempotent**, meaning you can run it multiple times safely to update your links if you add new files or pull updates from the repository.

## Adding New Configs

To add a new application to this repo:
1. Create a folder named after the application.
2. If the config goes in `~/.config`, create a `.config` folder inside your new folder and put the config there.
3. If the config goes in `~/` (like `.bashrc`), put it in the root of the new folder.
4. Run `./scripts/setup_symlinks.sh` to apply the changes.
