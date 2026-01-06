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
backup_and_link "$DOTFILES_DIR/.zshrc"      "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/.zshenv"     "$HOME/.zshenv"
backup_and_link "$DOTFILES_DIR/.gitconfig"  "$HOME/.gitconfig"
backup_and_link "$DOTFILES_DIR/.fzf.zsh"    "$HOME/.fzf.zsh"
backup_and_link "$DOTFILES_DIR/.editorconfig" "$HOME/.editorconfig"
backup_and_link "$DOTFILES_DIR/.inputrc"    "$HOME/.inputrc"
backup_and_link "$DOTFILES_DIR/.tmux.conf"  "$HOME/.tmux.conf"

# Install config directory files
mkdir -p "$HOME/.config/git"
backup_and_link "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
backup_and_link "$DOTFILES_DIR/.config/git/ignore" "$HOME/.config/git/ignore"

# Install Ghostty config
echo "👻 Setting up Ghostty config..."
mkdir -p "$HOME/.config/ghostty"
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"

if [ -f "$DOTFILES_DIR/.config/ghostty/config" ]; then
    # Link to standard XDG location
    backup_and_link "$DOTFILES_DIR/.config/ghostty/config" "$HOME/.config/ghostty/config"
    
    # Also link to Ghostty's default macOS location
    GHOSTTY_DEFAULT="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    if [ -f "$GHOSTTY_DEFAULT" ] || [ -L "$GHOSTTY_DEFAULT" ]; then
        echo "📋 Backing up existing Ghostty default config"
        cp "$GHOSTTY_DEFAULT" "$BACKUP_DIR/" 2>/dev/null || true
    fi
    backup_and_link "$DOTFILES_DIR/.config/ghostty/config" "$GHOSTTY_DEFAULT"
    
    echo "✅ Ghostty configuration linked to both locations"
else
    echo "⚠️  No Ghostty config found - skipping"
fi

# Install Zed config
echo "🧩 Setting up Zed config..."
mkdir -p "$HOME/.config/zed"
mkdir -p "$HOME/Library/Application Support/Zed"

if [ -f "$DOTFILES_DIR/.config/zed/settings.json" ]; then
    backup_and_link "$DOTFILES_DIR/.config/zed/settings.json" "$HOME/.config/zed/settings.json"
else
    echo "⚠️  No Zed settings.json found - skipping"
fi

if [ -f "$DOTFILES_DIR/.config/zed/keymap.json" ]; then
    backup_and_link "$DOTFILES_DIR/.config/zed/keymap.json" "$HOME/.config/zed/keymap.json"
else
    echo "⚠️  No Zed keymap.json found - skipping"
fi

if [ -d "$DOTFILES_DIR/.config/zed/extensions" ]; then
    echo "🧩 Installing Zed extensions snapshot..."
    mkdir -p "$HOME/Library/Application Support/Zed/extensions"

    # Back up existing extensions (directory copy; best-effort)
    if [ -d "$HOME/Library/Application Support/Zed/extensions" ] && [ ! -L "$HOME/Library/Application Support/Zed/extensions" ]; then
        cp -R "$HOME/Library/Application Support/Zed/extensions" "$BACKUP_DIR/" 2>/dev/null || true
    fi

    rsync -a "$DOTFILES_DIR/.config/zed/extensions/" "$HOME/Library/Application Support/Zed/extensions/" 2>/dev/null || \
        cp -R "$DOTFILES_DIR/.config/zed/extensions/." "$HOME/Library/Application Support/Zed/extensions/"
else
    echo "ℹ️  No Zed extensions snapshot found - skipping"
fi

# Install Claude Code settings
echo "🤖 Setting up Claude Code settings..."
mkdir -p "$HOME/.claude"

if [ -f "$DOTFILES_DIR/.claude/settings.json" ]; then
    backup_and_link "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"
    echo "✅ Claude Code main settings configured"
fi

if [ -f "$DOTFILES_DIR/.claude/settings.local.json" ]; then
    backup_and_link "$DOTFILES_DIR/.claude/settings.local.json" "$HOME/.claude/settings.local.json"
    echo "✅ Claude Code local settings configured"
fi

if [ ! -f "$DOTFILES_DIR/.claude/settings.json" ] && [ ! -f "$DOTFILES_DIR/.claude/settings.local.json" ]; then
    echo "⚠️  No Claude settings found - skipping"
fi

# Install custom scripts
echo "🛠️ Setting up custom scripts..."
if [ -d "$DOTFILES_DIR/bin" ]; then
    # Make sure all scripts in bin/ are executable
    chmod +x "$DOTFILES_DIR/bin/"*
    echo "✅ Custom scripts made executable"
else
    echo "⚠️  No bin directory found - creating empty one"
    mkdir -p "$DOTFILES_DIR/bin"
fi

# Install TPM (Tmux Plugin Manager) and plugins
echo "🔌 Setting up tmux plugins..."
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "📥 Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "📦 TPM already installed, updating..."
    git -C "$TPM_DIR" pull
fi

# Install tmux plugins
if command -v tmux &> /dev/null; then
    echo "📥 Installing tmux plugins..."
    # Clone plugins directly (more reliable than TPM script outside tmux)
    PLUGIN_DIR="$HOME/.tmux/plugins"

    for plugin in "tmux-plugins/tmux-resurrect" "tmux-plugins/tmux-continuum" "laktak/extrakto" "fcsonline/tmux-thumbs" "wfxr/tmux-fzf-url"; do
        plugin_name=$(basename "$plugin")
        if [ ! -d "$PLUGIN_DIR/$plugin_name" ]; then
            echo "  Installing $plugin_name..."
            git clone "https://github.com/$plugin" "$PLUGIN_DIR/$plugin_name"
        else
            echo "  $plugin_name already installed"
        fi
    done

    # Build tmux-thumbs (requires Rust, will skip if not available)
    if [ -d "$PLUGIN_DIR/tmux-thumbs" ] && command -v cargo &> /dev/null; then
        echo "  Building tmux-thumbs..."
        (cd "$PLUGIN_DIR/tmux-thumbs" && cargo build --release 2>/dev/null) || echo "  Skipping thumbs build (Rust not available)"
    fi

    echo "✅ tmux plugins installed"
else
    echo "⚠️  tmux not found, skipping plugin installation"
    echo "   Run 'Ctrl-a I' inside tmux to install plugins later"
fi

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
echo "📦 tmux plugins installed:"
echo "   - resurrect (Ctrl-a Ctrl-s to save, Ctrl-a Ctrl-r to restore)"
echo "   - continuum (auto-saves every 15 min)"
echo "   - extrakto (Ctrl-a Tab for fzf copy)"
echo "   - thumbs (Ctrl-a Space for hint copy)"
echo "   - fzf-url (Ctrl-a u to open URLs)"
echo ""
echo "🎉 Your development environment is ready!"
