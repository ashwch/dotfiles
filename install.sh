#!/bin/bash

# Dotfiles Installation Script
# This script creates symlinks for configuration files

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "🚀 Installing dotfiles..."

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo "📁 Created backup directory: $BACKUP_DIR"

# Function to backup and symlink files
backup_and_link() {
    local source="$1"
    local target="$2"
    
    if [ -f "$target" ] || [ -L "$target" ]; then
        echo "📋 Backing up existing $target"
        cp "$target" "$BACKUP_DIR/"
    fi
    
    echo "🔗 Linking $source -> $target"
    ln -sf "$source" "$target"
}

# Install main configuration files
backup_and_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
backup_and_link "$DOTFILES_DIR/.fzf.zsh" "$HOME/.fzf.zsh"

echo "✅ Dotfiles installation complete!"
echo "🔄 Reload your shell: source ~/.zshrc"
echo "📦 Backups stored in: $BACKUP_DIR"