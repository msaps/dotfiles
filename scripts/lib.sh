#!/bin/bash
# Shared helpers for the dotfiles setup scripts. Source this file; do not run it.

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() {
    echo "==> $*"
}

# Remove a broken symlink so mkdir -p can create a real directory in its place
ensure_dir() {
    local dir="$1"
    [ -L "$dir" ] && [ ! -e "$dir" ] && rm "$dir"
    mkdir -p "$dir"
}

ensure_xcode_clt() {
    if ! xcode-select -p &>/dev/null; then
        log "Installing Xcode Command Line Tools..."
        xcode-select --install
        echo "Press enter when the installation is complete."
        read -r
    fi
}

# Put an existing Homebrew on PATH, installing it first if it is missing
ensure_homebrew() {
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    if ! command -v brew &>/dev/null; then
        ensure_xcode_clt
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

# Install a Brewfile unless it is already satisfied or Homebrew is read-only.
# Never fails the caller, so linking still happens on locked-down machines.
brew_bundle() {
    local file="$DOTFILES_DIR/$1"
    ensure_homebrew
    if [ ! -w "$(brew --prefix)/Cellar" ]; then
        log "Skipping $1 (no write access to $(brew --prefix)/Cellar)"
    elif brew bundle check --file="$file" &>/dev/null; then
        log "$1 already satisfied"
    else
        log "Installing $1..."
        brew bundle --file="$file"
    fi
}

# Install a Homebrew package only when its command is not already on PATH.
# Usage: brew_ensure <command> <formula> | brew_ensure <command> --cask <cask>
brew_ensure() {
    local cmd="$1"
    shift
    command -v "$cmd" &>/dev/null && return 0
    ensure_homebrew
    if [ ! -w "$(brew --prefix)/Cellar" ]; then
        log "Skipping $cmd install (no write access to $(brew --prefix)/Cellar)"
    else
        log "Installing $cmd..."
        brew install "$@"
    fi
}

# Install a Homebrew cask only when its app bundle is not already present.
# Usage: brew_ensure_app <App.app> <cask>
brew_ensure_app() {
    local app="$1" cask="$2"
    [ -d "/Applications/$app" ] || [ -d "$HOME/Applications/$app" ] && return 0
    ensure_homebrew
    if [ ! -w "$(brew --prefix)/Cellar" ]; then
        log "Skipping $cask install (no write access to $(brew --prefix)/Cellar)"
    else
        log "Installing $cask..."
        brew install --cask "$cask"
    fi
}
