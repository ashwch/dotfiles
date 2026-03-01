# AGENTS.md

> Context for AI coding assistants (Claude Code, Cursor, Copilot, etc.)

## Overview

macOS development environment with **Ghostty/cmux** terminal setup. Fast shell startup (~50ms), modern CLI tools, keyboard-driven workflows.

## Architecture

### Terminal (Ghostty / cmux)

Both Ghostty and cmux (libghostty-based) read the same config (`~/.config/ghostty/config`):

```
Ghostty (tabs/windows/panes) → Shell
cmux (workspaces/tabs/panes) → Shell
```

- **Panes**: Cmd+D, Cmd+W etc. use native pane management in both terminals
- **tmux**: Optional — run `tmux-session` for session persistence, use Ctrl-a prefix for tmux panes

**Key files:**
| File | Purpose |
|------|---------|
| `.config/ghostty/config` | Shared config (read by both Ghostty and cmux) |
| `.tmux.conf` | tmux bindings, Gruvbox theme |
| `bin/tmux-session` | Smart session launcher with fzf (run manually) |

**tmux session picker** (`tmux-session`):
1. Run `tmux-session` in any terminal tab
2. fzf shows existing sessions + working directories
3. Select session, type new name, or Ctrl-f for zoxide directory picker
4. Sessions named `dirname-hash` (hash for worktree uniqueness)

**tmux plugins (via TPM):**
| Plugin | Purpose | Shortcut |
|--------|---------|----------|
| extrakto | Copy visible text with fzf | `Ctrl-a Tab` |
| thumbs | Copy with quick hints | `Ctrl-a Space` |
| fzf-url | Open URLs with fzf | `Ctrl-a u` |

### Shell & Tools

| Category | Tools |
|----------|-------|
| Shell | ZSH (~50ms startup), Starship prompt (Gruvbox) |
| Python | UV, auto-uv-env (auto-activates venv from pyproject.toml) |
| Node.js | Lazy-loaded NVM |
| CLI | eza, zoxide, ripgrep, fd, bat, fzf |
| Secrets | SOPS + age (encrypted, cached 5min) |

### Performance Targets

| Metric | Target | Current |
|--------|--------|---------|
| Shell startup | < 60ms | ~50ms |
| Cold cache startup | < 100ms | ~95ms |
| Secrets overhead | < 10ms | 5-7ms |

### Design Principles

1. **Lazy loading** — NVM, completions loaded on-demand
2. **Conditional config** — Tools only configured if installed
3. **Minimal frameworks** — No Oh-My-Zsh, only essential tmux plugins
4. **Symlink-based** — Easy updates, timestamped backups

## File Structure

```
dotfiles/
├── .zshrc                    # Shell config (aliases, functions, tools)
├── .tmux.conf                # tmux configuration
├── .gitconfig                # Git settings
├── bin/
│   └── tmux-session          # Session launcher (fzf + zoxide)
├── .config/
│   ├── ghostty/config        # Terminal config (Ghostty/cmux)
│   └── starship.toml         # Prompt theme
├── .claude/                  # Claude Code settings
├── Brewfile                  # Dependencies
├── setup.sh                  # One-command install
└── AGENTS.md                 # This file
```

## Development Patterns

### Python (UV + auto-uv-env)

Auto-activates venv on `cd` into Python projects:

```bash
cd /path/to/python-project/
# 🚀 Activated Python environment (Python 3.11.5)
```

Reads `requires-python` from `pyproject.toml`. First visit creates venv (~1-5s), subsequent visits ~5-10ms.

**Environment variables:**
- `AUTO_UV_ENV_QUIET=1` — Suppress output
- `AUTO_UV_ENV_DEBUG=1` — Debug logging

### Node.js (Lazy NVM)

NVM loads on first use to avoid startup penalty. Aliases: `nr` (npm run), `nd` (npm run dev).

### Git

Conventional commits. Common aliases: `gs` (status), `gp` (push), `gpoh` (push origin HEAD), `gmo` (merge origin).

## Common Commands

```bash
# Performance testing
time zsh -i -c exit

# Add package and update Brewfile
brew install <package>
brew bundle dump --force --file=Brewfile

# tmux sessions
tmux-session                     # Interactive session picker
tmux ls                          # List sessions
tmux attach -t <name>            # Attach
tmux kill-session -t <name>      # Kill

# Update dotfiles
./scripts/update-dotfiles
```

## Maintenance

When adding new tools:
1. Measure startup impact: `time zsh -i -c exit`
2. Use conditional loading: `command -v tool &>/dev/null && ...`
3. Update Brewfile if installed via Homebrew
4. Test that missing tools don't break config

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Slow startup | Profile with `zsh -x`, check lazy loading |
| Missing tool errors | Run `setup.sh`, check Brewfile |
| Broken symlinks | Re-run `setup.sh` (creates backups) |
| tmux not found | Check `/opt/homebrew/bin/tmux` exists |