#!/usr/bin/env bash

set -e

DOTFILES="$HOME/dotfiles"

echo "🍠 O1M0 dotfiles installer"
echo

# --------------------------------------------------
# Check
# --------------------------------------------------

if [ ! -d "$DOTFILES" ]; then
    echo "dotfiles not found: $DOTFILES"
    exit 1
fi

# --------------------------------------------------
# Directories
# --------------------------------------------------

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/o1m0"

# --------------------------------------------------
# Backup helper
# --------------------------------------------------

backup() {
    local target="$1"

    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ ! -L "$target" ]; then
            echo "backup: $target"
            mv "$target" "$target.backup"
        else
            rm "$target"
        fi
    fi
}

# --------------------------------------------------
# Neovim
# --------------------------------------------------

echo "linking Neovim..."

backup "$HOME/.config/nvim"

ln -s \
    "$DOTFILES/nvim" \
    "$HOME/.config/nvim"

# --------------------------------------------------
# zsh
# --------------------------------------------------

echo "linking zsh..."

backup "$HOME/.zshrc"

ln -s \
    "$DOTFILES/zsh/.zshrc" \
    "$HOME/.zshrc"

# --------------------------------------------------
# Boot Animation
# --------------------------------------------------

echo "linking boot animation..."

backup "$HOME/.config/o1m0/boot.sh"

ln -s \
    "$DOTFILES/zsh/boot.sh" \
    "$HOME/.config/o1m0/boot.sh"

chmod +x "$DOTFILES/zsh/boot.sh"

# --------------------------------------------------
# Finish
# --------------------------------------------------

echo
echo "🍠 dotfiles installed."
echo
echo "Neovim:"
readlink "$HOME/.config/nvim"

echo
echo "zsh:"
readlink "$HOME/.zshrc"

echo
echo "boot:"
readlink "$HOME/.config/o1m0/boot.sh"
