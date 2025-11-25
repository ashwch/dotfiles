# Dotfiles

Opinionated dotfiles for a fast, consistent macOS development environment.  
The setup is built around zsh, Homebrew, UV for Python, modern CLI tools, and a minimal but informative prompt.

---

## 1. Overview

This repository configures:

- zsh and Starship prompt
- Git (aliases, sensible defaults, rerere)
- Python development using UV and `auto-uv-env`
- Node.js development (npm, yarn, pnpm with lazy NVM)
- Modern CLI tools (fzf, eza, zoxide, ripgrep, fd, bat, etc.)
- Optional SOPS + age based secrets loading
- Editor/terminal integrations (Ghostty, Claude Code)

The goal is to make a fresh macOS machine productive in a few minutes, with repeatable setup and minimal manual steps.

---

## 2. Requirements

**Platform**
- macOS (tested on macOS 12 and newer)
- zsh as the login shell (default on modern macOS)

**Tools (installed automatically by the setup script if missing)**
- Xcode Command Line Tools
- Homebrew
- Git

**Recommended**
- A modern terminal (iTerm2, Ghostty, Warp, or Terminal.app)
- A Nerd Font (installed by the setup script)

You can also install everything manually if you prefer (see section 4.2).

---

## 3. What You Get

### 3.1 Shell and Prompt

- zsh with:
  - Carefully tuned history and completion
  - Smart directory navigation (zoxide)
  - Alias reminder system that suggests shorter commands
- Starship prompt with Git information and basic runtime indicators

### 3.2 Python Development

- UV-based workflow:
  - `pyrun` wrapper for `uv run` / `uvx`
  - `pynew` for creating new projects
- `auto-uv-env` integration:
  - Detects `pyproject.toml`
  - Creates and activates `.venv` with the correct Python version

### 3.3 Node.js / JavaScript

- Lazy-loaded NVM
- Aliases for npm, yarn, and pnpm common tasks (`ni`, `nr`, `nd`, etc.)

### 3.4 Git

- Short aliases:
  - `gs`, `ga`, `gc`, `gp`, `gpl`, `gl`, `gds`, etc.
  - `gpoh` for `git push origin HEAD`
  - `gmo <branch>` for `git merge origin/<branch>`
- Helpers:
  - `gclone` (clone and cd)
  - `gcom` (add-all + commit)
  - `gpush` (add-all + commit + push)

### 3.5 Secrets (Optional)

- SOPS + age integration for environment secrets stored in `.secrets.yaml`
- Cached, encrypted loading into the shell
- Convenience commands:
  - `refresh-secrets` to rebuild the cache

These features are only active if the required SOPS files and keys exist.

---

## 4. Installation

### 4.1 Automated Setup (Recommended)

Run the setup script on a fresh macOS system or a machine you are comfortable configuring:

```bash
git clone https://github.com/ashwch/dotfiles ~/dotfiles
cd ~/dotfiles

chmod +x setup.sh
./setup.sh
```

The script:

- Verifies macOS and installs Xcode Command Line Tools (if needed)
- Installs Homebrew (if needed) and core tools (zsh plugins, UV, modern CLI tools, NVM, etc.)
- Installs a Nerd Font for icon support
- Creates timestamped backups of existing config files
- Symlinks dotfiles into your home directory:
  - `~/.zshrc`
  - `~/.gitconfig`
  - `~/.fzf.zsh`
  - `~/.editorconfig`
  - `~/.inputrc`
  - `~/.config/starship.toml`
  - `~/.config/git/ignore`
  - Ghostty config (if present)
  - Claude Code settings (if present)
- Installs additional packages from the `Brewfile` (if present)

After the script finishes:

```bash
source ~/.zshrc
```

Optionally create a symlink for the global environment file:

```bash
ln -sf ~/dotfiles/.zshenv ~/.zshenv
```

### 4.2 Manual Installation

If you prefer to manage dependencies yourself:

```bash
git clone https://github.com/ashwch/dotfiles ~/dotfiles
cd ~/dotfiles

# Backup existing configs
cp ~/.zshrc     ~/.zshrc.backup     2>/dev/null || true
cp ~/.zshenv    ~/.zshenv.backup    2>/dev/null || true
cp ~/.gitconfig ~/.gitconfig.backup 2>/dev/null || true

# Symlink core files
ln -sf ~/dotfiles/.zshrc     ~/.zshrc
ln -sf ~/dotfiles/.zshenv    ~/.zshenv
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.fzf.zsh   ~/.fzf.zsh
ln -sf ~/dotfiles/.editorconfig ~/.editorconfig
ln -sf ~/dotfiles/.inputrc   ~/.inputrc

# Config directory
mkdir -p ~/.config/git
ln -sf ~/dotfiles/.config/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/.config/git/ignore    ~/.config/git/ignore

source ~/.zshrc
```

Install tools via Homebrew if needed:

```bash
brew install eza zoxide fzf ripgrep fd bat starship jq yq gh nvm
brew install --cask font-fira-code-nerd-font
```

---

## 5. Usage Highlights

### 5.1 Navigation and CLI Tools

- `z <dir>` – jump to frequently used directories (zoxide)
- `fcd` – fuzzy find and cd into a directory
- `ll`, `la`, `l` – enhanced directory listings (eza when available)
- `fvim` – fuzzy-open a file in `$EDITOR`

### 5.2 Python

- `pyrun <command>` – run Python commands in the project environment
- `pynew <name>` – create a new UV-based Python project
- `activate` – activate `.venv` in the current directory

### 5.3 Git

- Common aliases:
  - `gs` – `git status`
  - `ga` – `git add`
  - `gc` – `git commit`
  - `gp` – `git push`
  - `gpoh` – `git push origin HEAD`
  - `gmo feature` – `git merge origin/feature`
- Higher-level helpers:
  - `gclone <url>`
  - `gcom "message"`
  - `gpush "message"`

### 5.4 Secrets (if configured)

- `refresh-secrets` – clear and rebuild the SOPS secrets cache

---

## 6. Configuration Layout

Key files in this repository:

- `.zshenv` – global environment and PATH configuration
- `.zshrc` – interactive shell configuration
- `.gitconfig` – Git configuration and aliases
- `.fzf.zsh` – FZF bindings/completion
- `.editorconfig` – code style defaults
- `.inputrc` – readline configuration
- `.config/starship.toml` – prompt configuration
- `.config/ghostty/config` – Ghostty terminal configuration (optional)
- `.claude/` – Claude Code settings (optional)
- `scripts/` – helper and maintenance scripts
- `bin/` – custom commands automatically added to `PATH`

You can add machine- or work-specific settings in:

- `~/.zshrc.work` – sourced from `.zshrc` if present

---

## 7. Troubleshooting

**Check shell**

```bash
echo "$SHELL"
```

Expected: `/bin/zsh`.

**Measure startup time**

```bash
time zsh -i -c exit
```

If startup feels slow, temporarily move any local overrides (for example `~/.zshrc.work`) and retry.

**Verify tools**

```bash
eza --version
zoxide --version
fzf --version
rg --version
uv --version
```

If a tool is missing, install it via Homebrew or re-run `setup.sh`.

---

## 8. Uninstall

To revert to your previous configuration:

1. Restore backups created by `setup.sh` (directories named `~/dotfiles_backup_YYYYMMDD_HHMMSS`):

```bash
ls ~/dotfiles_backup_*
# copy back the files you care about, for example:
cp ~/dotfiles_backup_YYYYMMDD_HHMMSS/.zshrc ~/.zshrc
cp ~/dotfiles_backup_YYYYMMDD_HHMMSS/.gitconfig ~/.gitconfig
```

2. Remove symlinks you no longer want:

```bash
rm -f ~/.zshrc ~/.zshenv ~/.gitconfig ~/.fzf.zsh ~/.editorconfig ~/.inputrc
rm -f ~/.config/starship.toml ~/.config/git/ignore
```

3. Optionally remove Claude settings and tools you installed solely for this setup.

---

## 9. License

MIT License. You are free to use, modify, and adapt these dotfiles for your own environment.

