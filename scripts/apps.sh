#!/bin/bash
# Applications and machine-level setup: Homebrew apps, fonts, macOS defaults.
set -e
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

log "Configuring macOS defaults..."
if ! defaults read com.apple.finder AppleShowAllFiles 2>/dev/null | grep -q "1"; then
    defaults write com.apple.finder AppleShowAllFiles -bool true
    killall Finder 2>/dev/null || true
fi

ensure_homebrew
if [ -w "$(brew --prefix)/Cellar" ] && ! brew bundle check --file="$DOTFILES_DIR/Brewfile.apps" &>/dev/null; then
    log "Trusting Homebrew taps..."
    brew tap productdevbook/tap
    brew tap steipete/tap
    brew trust productdevbook/tap
    brew trust steipete/tap
fi
brew_bundle Brewfile.apps

log "Installing iTerm2 fonts..."
mkdir -p "$HOME/Library/Fonts"
cp "$DOTFILES_DIR/iterm/"*.ttf "$HOME/Library/Fonts/" 2>/dev/null || true

log "Apps setup complete."
echo "    Import the iTerm2 profile from: $DOTFILES_DIR/iterm/iterm-profiles.json"
