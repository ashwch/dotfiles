#!/bin/bash

# Complete macOS Development Environment Setup
# Run this script on a fresh macOS system

set -e

echo "🍎 Setting up macOS Development Environment"
echo "==========================================="

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is designed for macOS only"
    exit 1
fi

# Install Command Line Tools if not present
if ! xcode-select -p &> /dev/null; then
    echo "📦 Installing Command Line Tools..."
    xcode-select --install
    echo "⏳ Please complete the Command Line Tools installation and re-run this script"
    exit 0
fi

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "📦 Installing essential tools via Homebrew..."

# Core tools required by .zshrc
brew install \
    git \
    starship \
    zsh-syntax-highlighting \
    zsh-autosuggestions

# Modern CLI replacements
brew install \
    eza \
    zoxide \
    fzf \
    ripgrep \
    fd \
    bat \
    jq \
    yq

# Development tools
brew install \
    gh \
    nvm

# Optional but useful tools
brew install \
    thefuck \
    btop \
    httpie \
    tmux \
    tree

# Install fonts for better terminal experience
echo "🔤 Installing Nerd Fonts..."
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font

# Setup FZF key bindings
echo "🔍 Setting up FZF..."
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc

# Setup NVM directory
echo "📂 Setting up NVM..."
mkdir -p ~/.nvm

# Install Python with UV (separate installer for latest version)
echo "🐍 Setting up Python environment..."
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "✅ All tools installed successfully!"
echo ""
echo "🔗 Setting up dotfiles..."

# Create backup directory
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
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
DOTFILES_DIR="$HOME/dotfiles"
backup_and_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
backup_and_link "$DOTFILES_DIR/.fzf.zsh" "$HOME/.fzf.zsh"
backup_and_link "$DOTFILES_DIR/.editorconfig" "$HOME/.editorconfig"
backup_and_link "$DOTFILES_DIR/.inputrc" "$HOME/.inputrc"

# Install config directory files
mkdir -p "$HOME/.config/git"
backup_and_link "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
backup_and_link "$DOTFILES_DIR/.config/git/ignore" "$HOME/.config/git/ignore"

# Install packages from Brewfile
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo "📦 Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
fi

echo "✅ Dotfiles installed successfully!"

echo ""
echo "📝 Final configuration steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Install Node.js: nvm install node"
echo "3. Configure Git with your details:"
echo "   git config --global user.name \"Your Name\""
echo "   git config --global user.email \"your.email@example.com\""
echo ""
echo "🎉 Your development environment is ready!"