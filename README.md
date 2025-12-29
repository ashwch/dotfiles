# Dotfiles

> Opinionated macOS development environment with a hybrid Ghostty + tmux terminal setup.

Fast shell startup (~50ms), modern CLI tools, and keyboard-driven workflows.

## Highlights

- **Hybrid Terminal** — Ghostty handles tabs, tmux handles panes (with session persistence)
- **Smart Session Picker** — fzf-powered session management with zoxide integration
- **Native Shortcuts** — Cmd+D, Cmd+W work exactly like Ghostty, but control tmux
- **Fast Shell** — Lazy loading, conditional configuration, ~50ms startup
- **Modern Tools** — eza, zoxide, ripgrep, fd, bat, fzf, starship
- **Python/Node Ready** — UV + auto-uv-env, lazy NVM

---

## Quick Start

```bash
git clone https://github.com/ashwch/dotfiles ~/dotfiles
cd ~/dotfiles && ./setup.sh
```

---

## Terminal: Ghostty + tmux

The killer feature. Native macOS terminal experience with tmux session persistence.

```
┌─ Ghostty ──────────────────────────────────────────────────────────────────┐
│  Tab 1: backend    Tab 2: frontend    Tab 3: docs                          │
├────────────────────────────────────────────────────────────────────────────┤
│ ┌─ tmux session: backend ────────────────────────────────────────────────┐ │
│ │                                │                                       │ │
│ │  $ vim server.py               │  $ docker logs -f api                 │ │
│ │                                │                                       │ │
│ │                                │                                       │ │
│ ├────────────────────────────────┴───────────────────────────────────────┤ │
│ │  $ pytest -x                                                           │ │
│ │                                                                        │ │
│ └────────────────────────────────────────────────────────────────────────┘ │
│  session: backend │ user@host │ 14:32                                      │
└────────────────────────────────────────────────────────────────────────────┘
```

### Smart Session Picker

Open a new tab → fzf picker appears:

```
┌─────────────────────────────────────────────────────┐
│ Current: ~/projects/api                             │
│ Select session, type name, or Ctrl-f for directory │
├─────────────────────────────────────────────────────┤
│ > [+] Create new session                            │
│   [~] Pick directory (Ctrl-f)                       │
│   backend   │  ~/projects/api                       │
│   frontend  │  ~/work/webapp                        │
│   main      │  ~                                    │
└─────────────────────────────────────────────────────┘
```

- **Select session** → Attach
- **Type name** → Create new
- **Type path** → cd + create
- **Ctrl-f** → Browse zoxide history

### Keyboard Shortcuts

Pane shortcuts match Ghostty native, but control tmux:

| Shortcut | Action |
|----------|--------|
| `Cmd+D` | Split right |
| `Cmd+Shift+D` | Split down |
| `Cmd+Option+Arrow` | Navigate panes |
| `Cmd+Ctrl+Arrow` | Resize panes |
| `Cmd+W` | Close pane |
| `Cmd+Shift+Enter` | Toggle zoom |
| `Ctrl-a Ctrl-a` | Last pane |
| `Ctrl-a d` | Detach |

Tabs and windows use Ghostty native shortcuts (`Cmd+T`, `Cmd+N`, `Cmd+1-9`).

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
| Git | Comprehensive aliases (`gs`, `gp`, `gpoh`, `gmo`) |

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
```

---

## File Structure

```
dotfiles/
├── .zshrc                  # Shell configuration
├── .tmux.conf              # tmux + Ghostty integration
├── .gitconfig              # Git aliases and settings
├── bin/
│   └── tmux-session        # Smart session launcher
├── .config/
│   ├── ghostty/config      # Terminal + tmux keybindings
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
command -v tmux fzf zoxide eza

# Test session picker
tmux-session --help
```

---

## Requirements

- macOS 12+
- Ghostty (recommended) or any terminal
- Homebrew

---

## License

MIT
