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

## Installation

### Complete Setup (Recommended)

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the setup script:
   ```bash
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
- `start_dashboard_app.sh` - Example dashboard launcher
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
- `~/.zshrc.local` - Personal overrides
- `~/.zshrc.work` - Work-specific configuration

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

## License

MIT License - Feel free to use and modify as needed.