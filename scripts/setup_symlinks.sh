#!/bin/bash

# setup_symlinks.sh - Automate symlinking of dotfiles to ~/.config and ~/
# Usage:
#   ./setup_symlinks.sh              → crée les symlinks
#   ./setup_symlinks.sh --dry-run    → simule sans modifier
#   ./setup_symlinks.sh --unlink     → supprime les symlinks (restaure les sauvegardes si dispo)
#   ./setup_symlinks.sh --brew       → installe les paquets via Homebrew
#   ./setup_symlinks.sh --help       → affiche l'aide

set -euo pipefail

DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.dotfiles_backup"
DRY_RUN=false
UNLINK=false
RUN_BREW=false

# ── Couleurs ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

log_info() { echo -e "${BLUE}  →${RESET} $*"; }
log_success() { echo -e "${GREEN}  ✓${RESET} $*"; }
log_warn() { echo -e "${YELLOW}  ⚠${RESET} $*"; }
log_error() { echo -e "${RED}  ✗${RESET} $*" >&2; }
log_remove() { echo -e "${CYAN}  ✕${RESET} $*"; }

# ── Arguments ──────────────────────────────────────────────────────────────────
for arg in "$@"; do
    case $arg in
    --dry-run)
        DRY_RUN=true
        echo -e "${YELLOW}[DRY RUN — aucun fichier ne sera modifié]${RESET}\n"
        ;;
    --unlink)
        UNLINK=true
        echo -e "${CYAN}[MODE UNLINK — suppression des symlinks]${RESET}\n"
        ;;
    --brew)
        RUN_BREW=true
        ;;
    --help)
        echo "Usage: $0 [--dry-run | --unlink | --brew]"
        echo ""
        echo "  (aucun argument)  Crée les symlinks depuis le dossier dotfiles"
        echo "  --dry-run         Simule sans modifier le système"
        echo "  --unlink          Supprime les symlinks gérés (restaure les sauvegardes si disponibles)"
        echo "  --brew            Installe les paquets via Homebrew (Brewfile)"
        echo "  --help            Affiche cette aide"
        exit 0
        ;;
    *)
        log_error "Argument inconnu : $arg"
        echo "Lance '$0 --help' pour voir les options."
        exit 1
        ;;
    esac
done

echo -e "${BLUE}Dotfiles :${RESET} $DOTFILES_DIR\n"

# ── Collecte des cibles gérées ─────────────────────────────────────────────────
# Retourne dans stdout la liste des (src dst) que le script gèrerait
collect_targets() {
    # 1. Dossiers d'applications
    for app_dir in "$DOTFILES_DIR"/*/; do
        app_dir=${app_dir%/}
        app_name=$(basename "$app_dir")
        [[ "$app_name" == "scripts" || "$app_name" == "gemini" || "$app_name" == .* ]] && continue

        if [ -d "$app_dir/.config" ]; then
            for item in "$app_dir/.config"/* "$app_dir/.config"/.*; do
                [ -e "$item" ] || continue
                base=$(basename "$item")
                [[ "$base" == "." || "$base" == ".." ]] && continue
                echo "$item $CONFIG_DIR/$base"
            done
        fi

        for item in "$app_dir"/.*; do
            [ -e "$item" ] || continue
            base=$(basename "$item")
            [[ "$base" == "." || "$base" == ".." || "$base" == ".config" ]] && continue
            echo "$item $HOME/$base"
        done
    done

    # 2. Cas particuliers (Brewfile à la racine)
    if [ -f "$DOTFILES_DIR/Brewfile" ]; then
        echo "$DOTFILES_DIR/Brewfile $HOME/.Brewfile"
    fi
}

# ── Mode UNLINK ────────────────────────────────────────────────────────────────
run_unlink() {
    local removed=0
    local restored=0
    local skipped=0

    # Chercher la sauvegarde la plus récente
    local latest_backup=""
    if [ -d "$BACKUP_DIR" ]; then
        latest_backup=$(ls -1t "$BACKUP_DIR" 2>/dev/null | head -n1)
    fi

    while IFS=' ' read -r src dst; do
        if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
            if $DRY_RUN; then
                log_remove "[dry-run] Supprimerait le lien : $dst"
            else
                rm "$dst"
                log_remove "Lien supprimé : $dst"
                ((removed++)) || true

                # Restauration depuis sauvegarde si disponible
                if [ -n "$latest_backup" ]; then
                    local backup_file="$BACKUP_DIR/$latest_backup/$(basename "$dst")"
                    if [ -e "$backup_file" ]; then
                        cp -r "$backup_file" "$dst"
                        log_success "Restauré depuis sauvegarde : $(basename "$dst")"
                        ((restored++)) || true
                    fi
                fi
            fi
        elif [ -L "$dst" ]; then
            # Lien cassé pointant vers autre chose
            log_warn "Ignoré (lien non géré) : $dst"
            ((skipped++)) || true
        else
            log_info "Ignoré (pas un symlink) : $dst"
            ((skipped++)) || true
        fi
    done < <(collect_targets)

    echo ""
    if $DRY_RUN; then
        echo -e "${YELLOW}(Dry-run — aucun fichier modifié)${RESET}"
    else
        echo -e "${GREEN}✓ Unlink terminé${RESET} — supprimés: $removed | restaurés: $restored | ignorés: $skipped"
        [ -n "$latest_backup" ] && echo -e "  Sauvegarde utilisée : $BACKUP_DIR/$latest_backup"
    fi
}

# ── Fonction de création de symlink ───────────────────────────────────────────
make_link() {
    local src="$1"
    local dst="$2"

    # Lien déjà correct → skip
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        log_info "Déjà lié : $(basename "$dst")"
        return
    fi

    # Lien cassé → supprimer
    if [ -L "$dst" ] && [ ! -e "$dst" ]; then
        log_warn "Lien cassé supprimé : $dst"
        $DRY_RUN || rm "$dst"
    fi

    # Fichier/dossier réel existant → sauvegarde
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        local session_backup="${BACKUP_SESSION_DIR:-}"
        if [ -z "$session_backup" ]; then
            log_warn "Sauvegarde impossible (session non initialisée) : $dst"
        else
            log_warn "Sauvegarde : $(basename "$dst") → $session_backup/"
            $DRY_RUN || {
                cp -r "$dst" "$session_backup/"
                rm -rf "$dst"
            }
        fi
    fi

    if $DRY_RUN; then
        log_info "[dry-run] Lierait : $(basename "$dst") → $src"
    else
        ln -sfn "$src" "$dst"
        log_success "$(basename "$dst") → $src"
    fi
}

# ── Mode Homebrew ─────────────────────────────────────────────────────────────
run_brew() {
    if ! command -v brew &>/dev/null; then
        log_error "Homebrew n'est pas installé. Installe-le d'abord : https://brew.sh/"
        return 1
    fi

    if [ ! -f "$DOTFILES_DIR/Brewfile" ]; then
        log_error "Aucun Brewfile trouvé dans $DOTFILES_DIR"
        return 1
    fi

    echo -e "${BLUE}▸ Homebrew (Brewfile)${RESET}"
    if $DRY_RUN; then
        log_info "[dry-run] Exécuterait : brew bundle install --file=\"$DOTFILES_DIR/Brewfile\""
    else
        log_info "Installation des paquets Homebrew..."
        brew bundle install --file="$DOTFILES_DIR/Brewfile"
        log_success "Installation Homebrew terminée"
    fi
}

# ── Mode LINK (défaut) ────────────────────────────────────────────────────────
run_link() {
    # Initialiser le dossier de sauvegarde de cette session
    export BACKUP_SESSION_DIR="$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)"

    mkdir -p "$CONFIG_DIR"

    # 1. Symlinks des dossiers d'applications
    for app_dir in "$DOTFILES_DIR"/*/; do
        app_dir=${app_dir%/}
        app_name=$(basename "$app_dir")
        [[ "$app_name" == "scripts" || "$app_name" == "gemini" || "$app_name" == .* ]] && continue

        echo -e "${BLUE}▸ $app_name${RESET}"

        if [ -d "$app_dir/.config" ]; then
            for item in "$app_dir/.config"/* "$app_dir/.config"/.*; do
                [ -e "$item" ] || continue
                base=$(basename "$item")
                [[ "$base" == "." || "$base" == ".." ]] && continue
                make_link "$item" "$CONFIG_DIR/$base"
            done
        fi

        for item in "$app_dir"/.*; do
            [ -e "$item" ] || continue
            base=$(basename "$item")
            [[ "$base" == "." || "$base" == ".." || "$base" == ".config" ]] && continue
            make_link "$item" "$HOME/$base"
        done
    done

    # 2. Symlinks des fichiers à la racine (Brewfile, etc.)
    if [ -f "$DOTFILES_DIR/Brewfile" ]; then
        echo -e "${BLUE}▸ Cas particuliers${RESET}"
        make_link "$DOTFILES_DIR/Brewfile" "$HOME/.Brewfile"
    fi

    echo ""
    echo -e "${GREEN}✓ Symlinks installés !${RESET}"
    $DRY_RUN && echo -e "${YELLOW}(Mode dry-run — relance sans --dry-run pour appliquer)${RESET}"
    [ -d "$BACKUP_SESSION_DIR" ] && echo -e "Sauvegardes dans : $BACKUP_SESSION_DIR"
}

# ── Dispatch ───────────────────────────────────────────────────────────────────
if $RUN_BREW; then
    run_brew
fi

if $UNLINK; then
    run_unlink
else
    # Si --brew était le seul argument, on ne lance pas forcément run_link
    # Mais par défaut, on lance run_link si --unlink n'est pas là
    run_link
fi
echo "Symlink setup complete!"
