# Dotfiles

My personal collection of configuration files and development environment setup.

## Overview

This repository contains my carefully curated dotfiles, focusing on a modern, fast, and productive development environment with consistent coding styles and comprehensive tooling.

## Features

### 🚀 Performance Optimized
- Fast shell startup with lazy loading
- Optimized completion system
- Smart alias reminder system

### 🐍 Python Development (UV)
- UV-based Python environment management
- **Automatic environment activation** - Intelligent system that reads `pyproject.toml` and auto-creates/activates venv with correct Python version
- **Pre-commit compatibility** - Ensures correct Python version for hooks
- **Team consistency** - Same Python version across all developers
- Quick project setup functions
- Modern package management aliases

### 🌳 Git Workflow
- Comprehensive git aliases
- Conventional commit helpers
- Advanced git functions

### 📦 Node.js Development
- Support for npm, yarn, and pnpm
- Lazy-loaded NVM for performance
- Common development task aliases

### 🛠️ Modern CLI Tools
- **eza** - Better `ls` replacement
- **zoxide** - Smart `cd` command
- **ripgrep** - Fast text search
- **fzf** - Fuzzy finder integration
- **starship** - Modern prompt
- **ZSH built-in correction** - Command typo correction (setopt CORRECT)

### 📝 Code Quality & Consistency
- **EditorConfig** - Consistent coding styles across editors
- **Enhanced readline** - Better shell input handling
- **Global Git ignore** - Project-agnostic ignore patterns

### 📦 Package Management
- **Brewfile** - Reproducible package installations
- **Update scripts** - Automated maintenance utilities

## 🔐 Secrets Management (Optional)

**Note:** Secrets management is completely optional. The dotfiles work perfectly without any secrets configuration.

Secure SOPS + age encryption with automatic shell integration for storing API keys, tokens, etc.

### Commands
- `secrets edit` - Edit secrets (auto-encrypts on save)
- `secrets show` - Display decrypted secrets
- `refresh-secrets` - Clear cache after changes

### Setup (Only if you need to store secrets)
1. Generate age key: `age-keygen -o ~/.config/sops/age/keys.txt`
2. Store the key safely (password manager recommended)
3. Secrets auto-decrypt on shell startup (5-7ms overhead)
4. If no secrets file exists, this feature is automatically skipped

### 🛠️ Custom Scripts
- **Version controlled** - Scripts in `bin/` directory tracked with dotfiles
- **Global availability** - Automatically added to PATH
- **Team sharing** - Custom tools shared across team members

### 🤖 Claude Code Integration
- **Complete settings tracking** - Both main and local Claude Code configuration
- **Hooks management** - Notification scripts and custom integrations
- **Permissions tracking** - Tool permissions version controlled
- **Team consistency** - Shared Claude configuration across developers
- **Automatic setup** - All settings configured on new machines

### 🐳 Docker & DevOps
- Docker and docker-compose aliases
- Container management shortcuts
- System monitoring tools

## Prerequisites

Before installing these dotfiles, ensure you have:

### Required
- **macOS** (tested on macOS 12+)
- **Terminal access** (Terminal.app, iTerm2, Warp, etc.)
- **Admin privileges** (for installing development tools)
- **Git** (usually pre-installed; verify with `git --version`)

### Recommended
- **Nerd Font** for full icon support (automatically installed via setup script)
- **iTerm2 or modern terminal** for best experience

### Shell Setup
If you're not already using zsh (default on macOS 10.15+):
```bash
# Check current shell
echo $SHELL

# Switch to zsh if needed (usually not required on modern macOS)
chsh -s /bin/zsh
```

## Installation

### Complete Setup (Recommended)

1. Clone this repository:
   ```bash
   git clone https://github.com/ashwch/dotfiles ~/dotfiles
   cd ~/dotfiles
   ```

2. Make the setup script executable and run it:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```
   
   This single script will:
   - Install Command Line Tools (if needed)
   - Install Homebrew (if needed) 
   - Install all required dependencies
   - Create symlinks for your dotfiles
   - Set up development tools

   **Note:** If Command Line Tools aren't installed, the script will prompt you to install them first, then re-run the script.

3. Restart your terminal and enjoy!

## Post-Installation Verification

After installation, verify everything is working correctly:

### 1. Check Your Shell
```bash
echo $SHELL
# Should output: /bin/zsh
```

### 2. Verify Starship Prompt
Your terminal should now show a colorful prompt with:
- Current directory
- Git branch (when in a git repository)
- Language versions (Python, Node.js, etc.)
- Command execution time

### 3. Test Key Aliases
```bash
# Git aliases
gs          # Should run 'git status'
ga .        # Should run 'git add .'

# Navigation
ll          # Should show detailed file listing with icons
z           # Should show zoxide help (smart cd)

# Python (if you have Python projects)
cd /path/to/python/project
# Should auto-activate Python environment if pyproject.toml exists
```

### 4. Check Performance
```bash
# Test shell startup time (should be under 100ms)
time zsh -i -c exit
```

### 5. Verify Tools Installation
```bash
# Check modern CLI tools
eza --version    # Better ls
zoxide --version # Smart cd
fzf --version    # Fuzzy finder
rg --version     # ripgrep
```

## What to Expect

After installation, you'll have:

### 🎨 **Visual Changes**
- **Colorful prompt** with git status, language versions, and icons
- **Syntax highlighting** in terminal commands
- **Icons in file listings** (with eza)

### ⚡ **Performance Improvements**
- **Fast shell startup** (~50-100ms)
- **Smart directory jumping** with `z` command
- **Intelligent tab completion**

### 🛠️ **New Commands Available**
- `z <directory>` - Jump to frequently used directories
- `fcd` - Fuzzy find and cd to directory
- `weather` - Get weather information
- `serve` - Start local HTTP server
- `backup <file>` - Create timestamped backups
- `extract <archive>` - Universal archive extractor

### 🐍 **Python Development**
- **Auto-environment activation** when entering Python projects
- `pyrun <command>` - Smart uv run/uvx wrapper
- `pynew <project>` - Create new Python project

### 📝 **Enhanced Git Workflow**
- Short aliases: `gs`, `ga`, `gc`, `gp`
- Conventional commit helpers
- Better diff and log output

### Manual Installation

If you already have the dependencies and want to just symlink the dotfiles:

```bash
# Backup existing configs
cp ~/.zshrc ~/.zshrc.backup
cp ~/.gitconfig ~/.gitconfig.backup

# Create symlinks
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig  
ln -sf ~/dotfiles/.fzf.zsh ~/.fzf.zsh
ln -sf ~/dotfiles/.editorconfig ~/.editorconfig
ln -sf ~/dotfiles/.inputrc ~/.inputrc

# Config directory files
mkdir -p ~/.config/git
ln -sf ~/dotfiles/.config/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/.config/git/ignore ~/.config/git/ignore

# Install packages from Brewfile
brew bundle --file=~/dotfiles/Brewfile

# Reload shell
source ~/.zshrc
```

## Key Aliases & Functions

### Navigation
- `z <dir>` - Smart cd (zoxide)
- `..`, `...` - Navigate up directories
- `fcd` - Fuzzy find directory

### Python Development
- `pyrun` - Smart uv run/uvx
- `pynew` - Create new Python project
- `activate` - Activate virtual environment

#### Auto UV Environment
The shell automatically manages Python environments using [auto-uv-env](https://github.com/ashwch/auto-uv-env):
- **Detects** Python projects via `pyproject.toml`
- **Extracts** required Python version from project config
- **Creates** virtual environments with correct Python version
- **Activates** on directory entry, **deactivates** on exit
- **Optimized** for performance (~0ms for non-Python directories)

### Git
- `gs` - git status
- `ga` - git add
- `gc` - git commit
- `gp` - git push
- `gconv` - Conventional commits

### Node.js
- `ni` - npm install
- `nr` - npm run
- `nd` - npm run dev

### Utilities
- `serve` - Quick HTTP server
- `weather` - Get weather info
- `backup` - Backup files with timestamp
- `extract` - Universal archive extractor

### Custom Scripts
Custom scripts are stored in `bin/` and automatically available:
- Add your own scripts to `~/dotfiles/bin/` for version control

## Smart Features

### Alias Reminder System
The configuration includes an intelligent reminder system that suggests shorter aliases when you use longer commands:

```bash
$ git status
💡 Tip: You can use 'gs' instead of 'git status'
```

### Utility Functions
- `show_aliases` - Display all available aliases
- `add_alias` - Add new aliases with auto-reminders
- `validate_aliases` - Check alias functionality


## Configuration Structure

- **Environment & Path** - XDG directories, language settings
- **ZSH Options** - History, completion, navigation settings
- **Tool Configurations** - Python, Node.js, Git setups
- **Aliases & Functions** - Productivity shortcuts
- **Modern Tools** - Integration with CLI utilities
- **Key Bindings** - Custom keyboard shortcuts

## Utility Scripts

The `scripts/` directory contains helpful maintenance utilities:

- **update-dotfiles** - Updates packages, Brewfile, and pulls latest dotfiles
  ```bash
  ./scripts/update-dotfiles
  ```

## Customization

### Local Configuration
Add machine-specific settings to:
- `~/.zshrc.work` - Work-specific configuration (non-secrets)

### Adding New Aliases
```bash
add_alias <name> <command>
```

## Dependencies

### Required Tools
- **zsh** - Shell
- **starship** - Prompt
- **uv** - Python package manager

### Recommended Tools
- **eza** - Better ls
- **zoxide** - Smart cd
- **fzf** - Fuzzy finder
- **ripgrep** - Fast search
- **fd** - Better find
- **bat** - Better cat
- **ZSH built-in correction** - Command typo correction (setopt CORRECT)

### Installation via Homebrew
```bash
brew install eza zoxide fzf ripgrep fd bat starship
brew install --cask font-fira-code-nerd-font
```

## Troubleshooting

### Common Issues

#### Setup Script Permission Denied
```bash
# If you get permission denied
chmod +x setup.sh
./setup.sh
```

#### Command Line Tools Installation Fails
```bash
# Manually install Xcode Command Line Tools
xcode-select --install
# Then re-run setup
./setup.sh
```

#### Homebrew Installation Issues
```bash
# If brew command not found after installation
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

#### Starship Prompt Not Showing
```bash
# Check if starship is installed
starship --version

# If not installed
brew install starship

# Restart terminal
```

#### Icons Not Displaying
- Install a Nerd Font (setup script does this automatically)
- Configure your terminal to use the Nerd Font
- For iTerm2: Preferences → Profiles → Text → Font

#### Slow Shell Startup
```bash
# Check startup time
time zsh -i -c exit

# If over 200ms, check for conflicting configurations
mv ~/.zshrc.local ~/.zshrc.local.backup  # If it exists
```

#### Python Auto-Environment Not Working
```bash
# Check if auto-uv-env is installed
auto-uv-env --version

# Verify pyproject.toml has requires-python
cat pyproject.toml | grep requires-python
```

### Getting Help

1. **Check the alias reminder system**: Type long commands and look for suggestions
2. **Review available aliases**: Run `show_aliases`
3. **Check tool versions**: Use `tool --version` for specific tools
4. **Reset to defaults**: See uninstall instructions below

## Uninstall

To remove these dotfiles and restore your previous configuration:

### 1. Restore Backup Files
```bash
# The setup script creates backups with timestamps
ls ~/dotfiles-backup-*

# Restore from most recent backup
cp ~/dotfiles-backup-YYYYMMDD-HHMMSS/.zshrc ~/.zshrc
cp ~/dotfiles-backup-YYYYMMDD-HHMMSS/.gitconfig ~/.gitconfig
# ... restore other files as needed
```

### 2. Remove Symlinks
```bash
# Remove dotfile symlinks
rm ~/.zshrc ~/.gitconfig ~/.fzf.zsh ~/.editorconfig ~/.inputrc
rm ~/.config/starship.toml ~/.config/git/ignore

# Remove Claude Code settings (if you don't want to keep them)
rm -rf ~/.claude
```

### 3. Remove Tools (Optional)
```bash
# Remove Homebrew packages (only if you don't need them for other projects)
brew uninstall eza zoxide fzf ripgrep fd bat starship uv
brew uninstall --cask font-fira-code-nerd-font
```

### 4. Clean Shell Configuration
```bash
# Switch back to default shell if needed
chsh -s /bin/bash

# Or keep zsh but with minimal configuration
echo "# Minimal zsh config" > ~/.zshrc
```

## License

MIT License - Feel free to use and modify as needed.