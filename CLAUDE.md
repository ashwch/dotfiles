# CLAUDE.md - Development Context & Guidelines

This file provides essential context for Claude Code when working with this dotfiles repository.

## Project Overview

This is a **comprehensive macOS development environment** setup using modern dotfiles patterns. The goal is to provide a fast, productive, and consistent development experience across different machines.

## Key Technologies & Tools

### Core Shell Configuration
- **ZSH** with performance optimizations (~105ms startup time)
- **Starship prompt** with Gruvbox theme and comprehensive language indicators
- **FZF integration** for fuzzy finding and enhanced shell interactions

### Development Tools
- **UV** for Python package management (modern, fast replacement for pip/pipenv)
- **NVM** for Node.js version management (lazy-loaded for performance)
- **Homebrew** for macOS package management with Brewfile for reproducibility

### Modern CLI Replacements
- **eza** instead of ls (better output, icons, git integration)
- **zoxide** instead of cd (smart directory jumping with frecency)
- **ripgrep** instead of grep (faster, better defaults)
- **bat** instead of cat (syntax highlighting, git integration)
- **fd** instead of find (faster, intuitive syntax)

### Code Quality & Consistency
- **EditorConfig** for consistent coding styles across editors
- **Enhanced readline** via .inputrc for better shell input handling
- **Global Git ignore** patterns for common development artifacts

## Architecture Decisions

### Performance Priorities
1. **Sub-120ms shell startup** - Currently achieving ~105ms
2. **Lazy loading** - NVM, completions, and heavy tools loaded on-demand
3. **Conditional loading** - Tools only configured if installed
4. **Minimal plugin approach** - No heavy frameworks like Oh-My-Zsh

### Organization Strategy
- **Single setup script** - Eliminated confusion of multiple installation scripts
- **Comprehensive automation** - From dependencies to configuration
- **Symlink-based** - Easy to update and maintain
- **Backup-safe** - Always creates timestamped backups

## File Structure & Purpose

```
dotfiles/
├── .zshrc                    # Main shell configuration (718 lines)
├── .gitconfig               # Git global settings
├── .fzf.zsh                 # Fuzzy finder configuration
├── .editorconfig            # Cross-editor coding standards
├── .inputrc                 # Enhanced readline behavior
├── .config/
│   ├── starship.toml        # Prompt configuration with Gruvbox theme
│   └── git/ignore           # Global gitignore patterns
├── scripts/
│   └── update-dotfiles      # Maintenance automation
├── Brewfile                 # Reproducible package management
├── setup.sh                 # Complete environment setup
├── README.md                # User documentation
└── CLAUDE.md                # This file - development context
```

## Development Patterns & Preferences

### Shell Configuration Approach
- **Extensive aliases** (100+ shortcuts) with smart reminder system
- **Function-based utilities** for complex operations
- **Conditional tool integration** - graceful degradation if tools missing
- **Clear sectioning** with comments for maintainability

### Git Workflow Preferences
- **Conventional commits** with helper functions
- **Comprehensive aliases** for common operations
- **Global ignore patterns** for IDE files, OS artifacts, etc.

### Python Development Setup
- **UV-first approach** - Modern, fast package management
- **Virtual environment automation** - Easy project setup
- **Alias shortcuts** for common operations (pyrun, pynew, etc.)

### Node.js Development Setup
- **Multi-package manager support** - npm, yarn, pnpm aliases
- **Lazy NVM loading** - Performance over convenience
- **Common development shortcuts** - nr (npm run), nd (npm run dev), etc.

## Maintenance Guidelines

### When Adding New Tools
1. **Performance check** - Measure impact on shell startup time
2. **Conditional loading** - Check if tool exists before configuration
3. **Alias integration** - Add to reminder system if creating shortcuts
4. **Documentation** - Update README with new features

### Update Workflow
1. Use `./scripts/update-dotfiles` for routine maintenance
2. Update Brewfile when adding new packages
3. Test startup time after major changes
4. Commit changes with descriptive messages

### Testing New Configurations
- Test on fresh shell sessions to verify startup time
- Verify all aliases and functions work correctly
- Check that missing tools don't break the configuration
- Ensure backups are created properly

## Common Tasks & Commands

### Adding New Packages
```bash
brew install <package>
brew bundle dump --force --file=Brewfile  # Update Brewfile
```

### Performance Testing
```bash
time zsh -i -c exit  # Measure startup time
```

### Updating Everything
```bash
./scripts/update-dotfiles
```

### Adding New Aliases
```bash
add_alias <name> <command>  # Automatically includes in reminder system
```

## Integration Points

### Claude Code Workflows
- **Lint commands**: The .zshrc includes references to running lint/typecheck
- **Git integration**: Comprehensive git aliases and functions
- **Development shortcuts**: Language-specific aliases and utilities
- **Project navigation**: zoxide and fzf for quick directory switching

### IDE/Editor Integration
- **EditorConfig** provides consistent formatting across all editors
- **Global git ignore** prevents IDE files from being committed
- **Shell integration** works with VS Code, terminal emulators

## Troubleshooting Common Issues

### Slow Startup Times
- Check for new tool integrations without lazy loading
- Profile with `zsh -x` to identify bottlenecks
- Consider adding conditional loading for new tools

### Missing Tool Errors
- Verify Brewfile includes all required packages
- Check conditional loading logic in .zshrc
- Run setup.sh to ensure all dependencies installed

### Broken Symlinks
- Use the backup directory created during installation
- Re-run setup.sh to recreate symlinks
- Check file permissions and paths

## Performance Targets

- **Shell startup**: < 120ms (current: ~105ms)
- **Command completion**: < 100ms for common completions
- **Directory switching**: Instant with zoxide
- **Git operations**: Fast with comprehensive aliases

This dotfiles setup represents a balance between comprehensive functionality and performance optimization, suitable for professional development work across multiple projects and environments.