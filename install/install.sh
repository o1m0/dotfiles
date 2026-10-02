#!/usr/bin/env bash

set -e

# ============================================================
# 🍠 O1M0 DOTFILES INSTALLER
# ============================================================

DOTFILES="$HOME/dotfiles"

ORANGE='\033[38;2;232;129;60m'
WHITE='\033[38;2;234;234;234m'
GRAY='\033[38;2;119;119;119m'
RESET='\033[0m'

info() {
    printf "${ORANGE}●${RESET} %s\n" "$1"
}

success() {
    printf "${ORANGE}✓${RESET} %s\n" "$1"
}

warn() {
    printf "${GRAY}! %s${RESET}\n" "$1"
}

# ============================================================
# Header
# ============================================================

clear

printf "\n"
printf "${ORANGE}🍠  O1M0 DOTFILES${RESET}\n"
printf "${GRAY}────────────────────────${RESET}\n\n"

# ============================================================
# Detect OS
# ============================================================

OS="$(uname -s)"

case "$OS" in
    Darwin)
        PLATFORM="macOS"
        ;;

    Linux)
        if grep -qi microsoft /proc/version 2>/dev/null; then
            PLATFORM="WSL"
        else
            PLATFORM="Linux"
        fi
        ;;

    *)
        PLATFORM="Unknown"
        ;;
esac

info "Platform: $PLATFORM"

# ============================================================
# Check repository
# ============================================================

if [ ! -d "$DOTFILES/.git" ]; then
    printf "\n"
    warn "dotfiles repository not found:"
    printf "%s\n" "$DOTFILES"
    exit 1
fi

success "dotfiles repository found"

# ============================================================
# Package installation
# ============================================================

install_macos_packages() {

    info "Checking Homebrew"

    if ! command -v brew >/dev/null 2>&1; then
        warn "Homebrew is not installed."
        printf "Install Homebrew first, then run this installer again.\n"
        exit 1
    fi

    success "Homebrew"

    packages=(
        git
        neovim
        zsh
        ripgrep
        fd
        fzf
    )

    for package in "${packages[@]}"; do
        if brew list "$package" >/dev/null 2>&1; then
            success "$package"
        else
            info "Installing $package"
            brew install "$package"
        fi
    done

    # WezTerm
    if command -v wezterm >/dev/null 2>&1; then
        success "WezTerm"
    else
        info "Installing WezTerm"
        brew install --cask wezterm
    fi
}

check_linux_packages() {

    commands=(
        git
        nvim
        zsh
        curl
    )

    for command_name in "${commands[@]}"; do

        if command -v "$command_name" >/dev/null 2>&1; then
            success "$command_name"
        else
            warn "$command_name is not installed"
        fi

    done
}

case "$PLATFORM" in

    macOS)
        install_macos_packages
        ;;

    WSL|Linux)
        check_linux_packages
        ;;

esac

# ============================================================
# Directories
# ============================================================

info "Creating config directories"

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/o1m0"

# ============================================================
# Backup
# ============================================================

backup() {

    local target="$1"

    if [ -L "$target" ]; then
        rm "$target"
        return
    fi

    if [ -e "$target" ]; then

        local backup_target="${target}.backup"

        if [ -e "$backup_target" ]; then
            backup_target="${target}.backup.$(date +%Y%m%d%H%M%S)"
        fi

        info "Backup: $target"

        mv "$target" "$backup_target"
    fi
}

# ============================================================
# Neovim
# ============================================================

info "Linking Neovim"

backup "$HOME/.config/nvim"

ln -s \
    "$DOTFILES/nvim" \
    "$HOME/.config/nvim"

success "Neovim"

# ============================================================
# zsh
# ============================================================

info "Linking zsh"

backup "$HOME/.zshrc"

ln -s \
    "$DOTFILES/zsh/.zshrc" \
    "$HOME/.zshrc"

success "zsh"

# ============================================================
# Boot Animation
# ============================================================

info "Linking boot animation"

backup "$HOME/.config/o1m0/boot.sh"

ln -s \
    "$DOTFILES/zsh/boot.sh" \
    "$HOME/.config/o1m0/boot.sh"

chmod +x "$DOTFILES/zsh/boot.sh"

success "Boot animation 🍠"

# ============================================================
# WezTerm - macOS
# ============================================================

if [ "$PLATFORM" = "macOS" ]; then

    info "Linking WezTerm"

    backup "$HOME/.wezterm.lua"

    ln -s \
        "$DOTFILES/wezterm/.wezterm.lua" \
        "$HOME/.wezterm.lua"

    success "WezTerm"
fi

# ============================================================
# WezTerm - WSL
# ============================================================

if [ "$PLATFORM" = "WSL" ]; then

    printf "\n"
    info "WezTerm config"

    printf "${GRAY}"
    printf "Windows WezTerm should link:\n\n"
    printf "  C:\\Users\\<USER>\\.wezterm.lua\n"
    printf "\n"
    printf "to:\n\n"
    printf "  %s\n" "$DOTFILES/wezterm/.wezterm.lua"
    printf "${RESET}\n"

fi

# ============================================================
# Verify links
# ============================================================

printf "\n"
info "Checking links"

printf "\nNeovim\n"
readlink "$HOME/.config/nvim" || true

printf "\nzsh\n"
readlink "$HOME/.zshrc" || true

printf "\nboot\n"
readlink "$HOME/.config/o1m0/boot.sh" || true

if [ "$PLATFORM" = "macOS" ]; then
    printf "\nWezTerm\n"
    readlink "$HOME/.wezterm.lua" || true
fi

# ============================================================
# Finish
# ============================================================

printf "\n"
printf "${GRAY}────────────────────────${RESET}\n"
printf "${ORANGE}🍠 DOTFILES READY${RESET}\n"
printf "${GRAY}Platform: %s${RESET}\n" "$PLATFORM"
printf "\n"
