# Dotfiles

My personal collection of configuration files and development environment setup.

## Overview

This repository contains my carefully curated dotfiles, focusing on a modern, fast, and productive development environment.

## Features

### 🚀 Performance Optimized
- Fast shell startup with lazy loading
- Optimized completion system
- Smart alias reminder system

### 🐍 Python Development (UV)
- UV-based Python environment management
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
- **thefuck** - Command correction

### 🐳 Docker & DevOps
- Docker and docker-compose aliases
- Container management shortcuts
- System monitoring tools

## Installation

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Backup your existing configuration:
   ```bash
   cp ~/.zshrc ~/.zshrc.backup
   ```

3. Create a symlink or copy the configuration:
   ```bash
   ln -sf ~/dotfiles/.zshrc ~/.zshrc
   ```

4. Reload your shell:
   ```bash
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
- **thefuck** - Command correction

### Installation via Homebrew
```bash
brew install eza zoxide fzf ripgrep fd bat starship
brew install --cask font-fira-code-nerd-font
```

## License

MIT License - Feel free to use and modify as needed.