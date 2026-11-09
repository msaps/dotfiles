#!/bin/bash
# Terminal setup: CLI tools, Oh My Zsh, and shell/git/tmux/gh configuration.
set -e
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

brew_bundle Brewfile.cli

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing Oh My ZSH..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    log "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

log "Linking terminal configuration..."

# ZSH
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
ln -sf "$DOTFILES_DIR/zsh/.profile" "$HOME/.profile"

# Git
ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/git/.gitignore" "$HOME/.gitignore"

# Misc
ln -sf "$DOTFILES_DIR/misc/.curlrc" "$HOME/.curlrc"
ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"

# Homebrew
mkdir -p "$HOME/.homebrew"
ln -sf "$DOTFILES_DIR/homebrew/brew.env" "$HOME/.homebrew/brew.env"

# GitHub CLI
mkdir -p "$HOME/.config/gh"
ln -sf "$DOTFILES_DIR/gh/config.yml" "$HOME/.config/gh/config.yml"

log "Terminal setup complete. Restart your terminal or run: exec zsh"
echo "    Remember to authenticate GitHub CLI: gh auth login"
