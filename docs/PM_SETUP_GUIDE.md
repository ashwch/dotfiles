# PM Mac Setup Guide (M1) - Diversio

Last updated: 2026-04-16

Goal
- Get a non-technical PM's M1 Mac ready for daily work with Claude Code, Codex CLI, ZSH + dotfiles, Postgres 17, Redis, and the Diversio monolith.
- Make every step copy/paste friendly, with a clear "why" and a quick success check.

Setup map (do this in order, but read it like a story)

[0 Access] -> [1 Claude Code] -> [2 Base tools] -> [3 Dotfiles] -> [4 Node + Codex] -> [5 Python + UV] -> [6 Services] -> [7 Monolith] -> [8 Verify]

Progress ladder (visual, you can check things off)
```text
[ ] 0 Access
[ ] 1 Claude Code
[ ] 2 Base tools
[ ] 3 Dotfiles
[ ] 4 Node + Codex
[ ] 5 Python + UV
[ ] 6 Services
[ ] 7 Monolith
[ ] 8 Verify
```

Mini mental model (visual)
```text
You type -> Shell (zsh) -> Tools (git, node, python) -> Project (monolith)
```

How to use this guide: open Terminal (Ghostty is recommended, macOS Terminal works), copy/paste commands one line at a time, and after each step run the Check command; if it fails, jump to “If stuck” at the end of that step. If something looks scary, do not guess—ask or paste the output into Claude Code or Codex.

Safety and first principles: you are building layers, and if a layer is missing everything above it breaks, so do not skip ahead; do not paste secrets into AI tools and redact tokens/passwords/private URLs first; if a command asks for a password, it is your Mac login password (not a website password).

Do not do this (quick warning box)
```text
Do NOT paste tokens or secrets into Claude Code/Codex.
Do NOT run rm -rf unless a teammate tells you exactly what to delete.
Do NOT force overwrite files with >| unless you are sure.
```

-----------------------------------------------------------------------

Command line + .zshrc basics (quick visual cheat sheet)

Here’s a clear, PM‑friendly explanation of what your shell config does and the command‑line basics that will help her feel confident. Everything below is based on /Users/monty/dotfiles/.zshrc, and it is intentionally written as a narrative wall of text so she can read it straight through.

Terminal basics (visual)
```text
┌──────────────────────────────────────┐
│ Command = verb + options + args      │
│ Example:                             │
│   ls -la /Users/monty                │
└──────────────────────────────────────┘

Pipes (connect commands):
  command1 | command2
  ps aux | rg python

Redirect output:
  echo "hi" > file.txt    (blocked by NO_CLOBBER)
  echo "hi" >| file.txt   (force overwrite)
  echo "hi" >> file.txt   (append)
```

.zshrc tour (what it does and why it matters): it exits early for non‑interactive shells so scripts stay fast and safe, it keeps a huge shared history across tabs with de‑dupe and adds safer defaults like `pipefail` and `NO_CLOBBER` so pipes fail if any step fails and accidental overwrites are blocked unless you use `>|`; it sets up fast tab completions with nice menus and colors; it standardizes Python via UV (helpers like `pynew`, `pyrun`, `activate`), and keeps Node simple with standalone pnpm plus `pnpm runtime` for installing/switching Node; it adds speed aliases for git/pnpm/tmux (including npm/yarn muscle‑memory aliases like `ni` for `pnpm install`), swaps in modern tools (`ls`→`eza`, `cd`→`z` via zoxide, `grep`→`rg` via ripgrep), auto‑activates Python envs when a `pyproject.toml` is found, loads secrets into env vars via SOPS with caching, adds FZF helpers for fuzzy find, and improves the prompt experience with Starship + syntax highlighting + autosuggestions + key bindings. If she asks “what should I change?” — the answer is “use `~/.zshrc.work` for personal tweaks; leave `.zshrc` alone.”

Command line basics (quick, practical, but in one place): use `pwd` to see where you are, `ls` to list files (it will look pretty because it’s `eza`), `cd folder` to move, `cd ..` to go up a level, `cd -` to jump back, and `~` is your home; use `mkdir mydir` to create folders and `touch file.txt` to create files; `open .` opens Finder at the current folder; `pbcopy` and `pbpaste` copy/paste on macOS; a command is structured like `command -flags --long-flag arg1 arg2` (example: `ls -la`), and you can connect commands using pipes like `ps aux | rg chrome`; redirect output with `>` (blocked by NO_CLOBBER), `>|` to force overwrite, or `>>` to append; check success with `echo $?` where `0` means success.

Environment variables (simple mental model): they are settings tools can read, you can set them for this terminal only with `export VAR=value` or for a single command with `VAR=value command`, list all with `env`, read one with `echo $VAR`, and in this setup secrets are loaded into env vars via SOPS so never paste them into AI tools. `source` loads a file into the current shell, so after editing `.zshrc.work` or `.zshrc` you run `source ~/.zshrc` or simply `reload` (an alias); `.` is a short version of `source`.

Tips & tricky parts (from my side): NO_CLOBBER means `>` won’t overwrite files so use `>|` only when you really mean it, `cd` is zoxide so it learns your folders and `cd project` might jump to your most‑used path, ripgrep replaces grep and can behave slightly differently, lazy‑loaded tools might say “command not found” until you open a new terminal tab, Shift‑Tab accepts autosuggestions, alias reminders gently nudge you toward shortcuts, and dangerous commands like `rm -rf`, `kill -9`, and `findreplace` should be used only when someone tells you exactly what to do; also, never paste tokens into AI tools and always redact before sharing outputs.

Environment variables (visual)
```text
┌──────────────────────────────────────────┐
│ VAR = a setting tools can read           │
│                                          │
│ export FOO=bar        # for this terminal│
│ FOO=bar command       # for one command  │
│ echo $FOO             # read it          │
└──────────────────────────────────────────┘
```

`source` command (visual)
```text
Edit a config file -> source it -> terminal updates
Example:
  source ~/.zshrc
  (or) reload
```

.zshrc load order (visual)
```text
~/.zshenv -> ~/.zshrc -> ~/.zshrc.work
         (team defaults)     (personal overrides)
```

Top 12 commands you will actually use (fast cheat list)
```text
pwd             # where am I?
ls              # list files (pretty)
cd <folder>     # move
cd ..           # up one level
open .          # open folder in Finder
code .          # open in editor (if installed)
git status      # see changes
git pull        # update
git checkout    # switch branch
node -v         # check node
uv --version    # check python tooling
redis-cli ping  # check redis
```

Mermaid quick map (visual)
```mermaid
flowchart LR
  A[You type a command] --> B[zsh shell]
  B --> C{Is it an alias?}
  C -->|yes| D[Expands (gs = git status)]
  C -->|no| E[Runs tool directly]
  D --> F[Tool runs]
  E --> F
  F --> G[Result printed in terminal]
```

-----------------------------------------------------------------------

Paste this into Claude Code or Codex when stuck (keep this near the top)
```text
I am stuck on step: <step name>
Command I ran:
<command>

Output:
<paste full terminal output here>

What I expected:
<expected result>
```

-----------------------------------------------------------------------

0) Access and accounts (10-20 min)

Why: You cannot clone private repos or use AI tools without accounts.

Do: install Keeper (company password manager) from https://keepersecurity.com/download, sign in, and confirm you can see shared vaults; make sure your GitHub account is added to the DiversioTeam org (if not, ask Engineering before continuing); confirm AI accounts are active (Claude Code requires Pro/Max, Codex CLI requires ChatGPT Pro or other supported business plans). Check: you can open Keeper and see shared items, and you can log in to GitHub in your browser. If stuck: ask Engineering to confirm your GitHub org access and AI tool seats.

-----------------------------------------------------------------------

1) Install Claude Code first (5-10 min)

Why: this becomes your helper for the rest of the setup and you can paste terminal output into it when stuck.

Do
```bash
curl -fsSL https://claude.ai/install.sh | bash
claude --version
claude doctor
```
Then run `claude` and follow the login prompts (use your Pro/Max account).

Expected output: `claude --version` prints a version, and `claude doctor` shows all green checks.

If stuck: re‑open Terminal and run `claude doctor` again; if install fails, re‑run the install command and paste the output into Claude Code for help.

-----------------------------------------------------------------------

2) Base tools: Git + Homebrew (10-20 min)

Why: Homebrew installs most of our tools and services.

Do
```bash
# Trigger Xcode Command Line Tools install (includes git)
git --version
```
If macOS prompts you, accept and wait for it to finish. Then install Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Expected output: `git --version` prints a git version, and `brew --version` prints a brew version.

If stuck: if `git` is missing, re‑run `git --version` to trigger install; if `brew` is not found, re‑run the Homebrew install command.

-----------------------------------------------------------------------

3) Dotfiles: ZSH, tmux, Ghostty config (10-20 min)

Why: this gives you the same shell and terminal workflow as the team.

Do
```bash
# Clone dotfiles (important: path must be ~/dotfiles for setup.sh)
git clone git@github.com:ashwch/dotfiles.git ~/dotfiles

# Install tools + symlinks
cd ~/dotfiles
./setup.sh
```

`./setup.sh` installs standalone pnpm + Node.js and runs `brew bundle` near the end, so Ghostty, Zed, cmux, fonts, and the rest of the Brewfile should be installed automatically.

If Homebrew had a network hiccup and you want to retry just the Brewfile packages, run:
```bash
brew bundle --file ~/dotfiles/Brewfile
```

Expected output: `zsh --version`, `tmux -V`, and `wt --version` print versions and do not error.

If stuck: if `git clone` fails (permission denied), run `brew install gh` then `gh auth login`, or use HTTPS clone URL; if `./setup.sh` stops after Xcode tools install, re‑run it.

Terminal model (visual)
```
Ghostty tab/window -> tmux session -> zsh
```

-----------------------------------------------------------------------

4) pnpm-managed Node + Codex CLI (10-15 min)

Why: `./setup.sh` installed pnpm-managed Node. Now we verify it and install Codex CLI as a global pnpm package.

Mental model:
```text
pnpm is the toolbox
  -> pnpm installs Node
  -> Node runs JavaScript tools like Codex
```

This setup avoids a common chicken-and-egg problem: Homebrew pnpm needs Node before it can run, but here pnpm is the thing that installs Node.

Do
```bash
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"
node -v
pnpm -v
```
Then install Codex CLI:
```bash
pnpm add -g @openai/codex
codex --version
```
Run once to log in: `codex`.

Expected output: `node -v` prints an LTS version, `pnpm -v` prints a version, `codex --version` prints a version, and `codex` opens a login flow.

Notes: pnpm runtime switching is global. If a repo explicitly needs an older Node version, a teammate may ask you to run something like `pnpm runtime set node 20.11.0 -g`; `.nvmrc` files are still useful version hints but do not require NVM.

If stuck: if `pnpm` is not found, rerun `cd ~/dotfiles && ./setup.sh`; if `codex` fails to log in, verify your ChatGPT Pro access.

-----------------------------------------------------------------------

5) Python + UV (5-10 min)

Why: backend uses uv for Python and dependencies.

Do
```bash
uv --version
```
If uv is missing:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Expected output: `uv --version` prints a version.

If stuck: close and re‑open Terminal, then try again.

-----------------------------------------------------------------------

6) Services: Postgres 17 and Redis (15-25 min)

Why: backend uses Postgres and Redis locally.

Install Postgres 17:
```bash
brew install postgresql@17
```
Add Postgres to your PATH (use .zshrc.work so dotfiles are safe):
```bash
cat <<'SH' >> ~/.zshrc.work
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
SH

source ~/.zshrc.work
```
Start Postgres and confirm:
```bash
brew services start postgresql@17
psql --version
```
Create the local database user and db (matches backend sample .env):
```bash
createuser -s postgres
psql -d postgres -c "ALTER USER postgres WITH PASSWORD 'password';"
createdb diversio_db
```
If you see “role already exists,” that is OK.

Install Redis:
```bash
brew install redis
brew services start redis
redis-cli ping
```

Expected output: `psql --version` prints 17.x; `redis-cli ping` prints PONG.

If stuck: if `psql` is not found, open a new Terminal tab and retry; if Redis fails to start, run `brew services list` and paste output into Claude Code.

-----------------------------------------------------------------------

7) Monolith setup (20-40 min)

Why: this is the unified repo that contains all core projects.

If the monolith already exists at `/Users/monty/work/diversio/monolith`, skip clone and go to “Update submodules.”

Clone (new machine):
```bash
mkdir -p ~/work/diversio
cd ~/work/diversio
git clone --recursive git@github.com:DiversioTeam/monolith.git
cd monolith
```
Update submodules (if already cloned):
```bash
cd ~/work/diversio/monolith
git submodule update --init --recursive
```
Backend quick start (requires .env from teammate):
```bash
cd ~/work/diversio/monolith/backend
uv sync
uv run python manage.py migrate --configuration=DevApp
uv run python manage.py runserver --configuration=DevApp
```
Frontend quick start (requires NPM_TOKEN for design system):
```bash
cd ~/work/diversio/monolith/frontend
export NPM_TOKEN=<ask a coworker>
pnpm install
pnpm start
```
Tip: do not commit NPM_TOKEN; store it in Keeper and set it only when needed.

Optimo frontend quick start:
```bash
cd ~/work/diversio/monolith/optimo-frontend
pnpm install
pnpm dev
```

Expected output: backend opens at http://localhost:8000/admin and frontend opens at http://localhost:3000.

If stuck: ask a teammate for the backend `.env` file; if `pnpm` is missing, rerun the Node setup step or `~/dotfiles/setup.sh`.

-----------------------------------------------------------------------

8) VM (only if you were told you need one)

Why: some workflows require a Linux or Windows VM.

Do: ask Engineering which VM tool is approved; if they say UTM, download it from https://mac.getutm.app; if they say something else (Parallels, VMware), follow the official installer.

Expected output: you can open the VM app and create a new VM.

If stuck: ask Engineering which VM image you should use.

-----------------------------------------------------------------------

Verification checklist (5 min)

Run these and confirm no errors:
```bash
claude --version
codex --version
brew --version
zsh --version
tmux -V
wt --version
uv --version
node -v
psql --version
redis-cli ping
```
Expected output: versions print with no errors and `redis-cli ping` prints PONG.

If any command fails, paste the output into Claude Code or Codex CLI and ask for a fix.

-----------------------------------------------------------------------

Troubleshooting (quick fixes)

"command not found": close the terminal, open a new one, and re‑run the command. "permission denied" while cloning: run `gh auth login` and try again. Postgres not running: run `brew services list` and look for postgresql@17 status. Redis not running: run `brew services list` and look for redis status. AI tools fail login: confirm you are on Claude Pro/Max and ChatGPT Pro.
