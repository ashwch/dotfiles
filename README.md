# Dotfiles

> Opinionated macOS development environment with Ghostty/cmux terminal setup.

Fast shell startup (~50ms), modern CLI tools, and keyboard-driven workflows.

## Highlights

- **Dual Terminal** — Ghostty and cmux share the same config with native pane management
- **Optional tmux** — Run `tmux-session` for session persistence, use prefix keys for tmux panes
- **Native Shortcuts** — Cmd+D, Cmd+W use native panes in both Ghostty and cmux
- **Fast Shell** — Lazy loading, conditional configuration, ~50ms startup
- **Modern Tools** — eza, zoxide, ripgrep, fd, bat, fzf, wt, starship
- **Python/Node Ready** — UV + auto-uv-env, lazy NVM

---

## Quick Start

```bash
git clone https://github.com/ashwch/dotfiles ~/dotfiles
cd ~/dotfiles && ./setup.sh
```

---

## Terminals

### Ghostty / cmux

Both terminals read the same `~/.config/ghostty/config`. Pane management uses native shortcuts.

| Shortcut | Action |
|----------|--------|
| `Cmd+D` | Split right |
| `Cmd+Shift+D` | Split down |
| `Cmd+Option+Arrow` | Navigate panes |
| `Cmd+Ctrl+Arrow` | Resize panes |
| `Cmd+W` | Close pane |
| `Cmd+Shift+Enter` | Toggle zoom |
| `Cmd+T` | New tab |
| `Cmd+N` | New window/workspace |

### tmux (optional)

Run `tmux-session` to start a tmux session with the fzf picker. Inside tmux, use prefix keys:

| Shortcut | Action |
|----------|--------|
| `Ctrl-a \|` | Split right |
| `Ctrl-a -` | Split down |
| `Ctrl-a h/j/k/l` | Navigate panes |
| `Ctrl-a H/J/K/L` | Resize panes |
| `Ctrl-a x` | Close pane |
| `Ctrl-a z` | Toggle zoom |
| `Ctrl-a d` | Detach |

**tmux plugins (via TPM):**

| Shortcut | Plugin | Action |
|----------|--------|--------|
| `Ctrl-a Tab` | extrakto | Copy any visible text with fzf |
| `Ctrl-a Space` | thumbs | Copy with quick hints |
| `Ctrl-a u` | fzf-url | Open URLs with fzf |

---

## What's Included

### Shell

- **zsh** with optimized startup
- **Starship** prompt (Gruvbox theme)
- **100+ aliases** with reminder system
- **zoxide** for smart directory jumping

### Development

| Language | Tools |
|----------|-------|
| Python | UV, auto-uv-env (auto-activates venv) |
| Node.js | Lazy-loaded NVM, npm/yarn/pnpm aliases |
| Git | Comprehensive aliases (`gs`, `gp`, `gpoh`, `gmo`), `wt` worktree dashboard |

### CLI Tools

| Instead of | Use |
|------------|-----|
| `ls` | `eza` (icons, git status) |
| `cd` | `zoxide` (frecency-based) |
| `grep` | `ripgrep` (faster) |
| `find` | `fd` (intuitive) |
| `cat` | `bat` (syntax highlighting) |

---

## Installation

### Automated (Recommended)

```bash
git clone https://github.com/ashwch/dotfiles ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The script installs dependencies, creates backups, and symlinks configs.

### Manual

```bash
# Clone
git clone https://github.com/ashwch/dotfiles ~/dotfiles

# Symlink
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

# Config directories
mkdir -p ~/.config/ghostty
ln -sf ~/dotfiles/.config/ghostty/config ~/.config/ghostty/config
ln -sf ~/dotfiles/.config/starship.toml ~/.config/starship.toml

# Install tools
brew install tmux fzf zoxide eza ripgrep fd bat starship
brew install ashwch/tap/auto-uv-env ashwch/tap/wt
```

---

## File Structure

```
dotfiles/
├── .zshrc                  # Shell configuration
├── .tmux.conf              # tmux configuration
├── .gitconfig              # Git aliases and settings
├── bin/
│   ├── tmux-session        # Smart session launcher
│   └── code                # VS Code-compatible shim -> zed
├── .config/
│   ├── ghostty/config      # Terminal config (Ghostty/cmux)
│   ├── zed/                # Zed editor configuration
│   │   ├── settings.json   # Zed editor settings
│   │   └── keymap.json     # Zed keybindings
│   └── starship.toml       # Prompt theme
├── Brewfile                # Dependencies
└── setup.sh                # One-command install
```

---

## Customization

### Machine-Specific Settings

Create `~/.zshrc.work` — automatically sourced if present.

### Secrets

Uses SOPS + age for encrypted secrets in `.secrets.yaml`.

```bash
refresh-secrets  # Rebuild cache
```

---

## Troubleshooting

```bash
# Check startup time
time zsh -i -c exit

# Verify tools
command -v tmux fzf zoxide eza wt

# Test session picker
tmux-session --help

# Test worktree dashboard
wt --help
```

---

## Requirements

- macOS 12+
- Ghostty or cmux (recommended) or any terminal
- Homebrew

---

## License

MIT
