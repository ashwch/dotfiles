# =====================================================
# Modern, Fast ZSH Configuration
# =====================================================

# Performance: Early exit for non-interactive shells
[[ $- != *i* ]] && return

# =====================================================
# ZSH Options & Settings
# =====================================================

# Global environment (LANG, EDITOR, PATH, etc.) now lives
# in ~/.zshenv so that non-interactive zsh shells (e.g.
# `zsh -c` from other tools) see the same setup.

# History settings
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# Safer defaults: fail when any command in a pipeline
# fails, and avoid clobbering files accidentally.
set -o pipefail        # Return status from rightmost failing command in a pipeline
setopt NO_CLOBBER      # Prevent '>' from truncating files; use '>|' to override

# Directory navigation
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

# Tab completion
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# Other useful options
setopt CORRECT
setopt GLOBDOTS
setopt NO_BEEP

# Optional startup profiling: set ZSH_PROFILE=1 before
# starting a shell to enable zprof, then run `zprof`
# after startup to see where time is spent.
if [[ -n "$ZSH_PROFILE" ]]; then
    zmodload zsh/zprof
fi

# =====================================================
# Completion System
# =====================================================

# Initialize completion system
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' squeeze-slashes true

# Enable completion for common tools (commented out for faster startup)
# Uncomment these if you need advanced completions for these tools:
# command -v uv >/dev/null 2>&1 && source <(uv generate-shell-completion zsh)  
# command -v gh >/dev/null 2>&1 && source <(gh completion -s zsh)

# =====================================================
# Python Development (UV)
# =====================================================

# UV global configuration
export UV_PYTHON_PREFERENCE=managed
export UV_PROJECT_ENVIRONMENT=.venv

# Python aliases
alias py="python3"
alias pip="uv pip"
alias pipx="uvx"
alias venv="uv venv"
alias activate="source .venv/bin/activate"

# Quick project setup
pynew() {
    local name=${1:-$(basename "$PWD")}
    uv init "$name" && cd "$name" && uv venv && source .venv/bin/activate
}

pyrun() {
    if [[ -f pyproject.toml ]]; then
        uv run "$@"
    else
        uvx "$@"
    fi
}

# =====================================================
# Node.js Development
# =====================================================

# NVM Configuration (lazy loading for speed)
export NVM_DIR="$HOME/.nvm"
nvm() {
    unset -f nvm
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    nvm "$@"
}

# Node aliases
alias ni="npm install"
alias nid="npm install --save-dev"
alias nig="npm install --global"
alias nr="npm run"
alias ns="npm start"
alias nt="npm test"
alias nb="npm run build"
alias nd="npm run dev"

# Yarn alternatives
alias yi="yarn install"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yr="yarn run"
alias ys="yarn start"
alias yt="yarn test"
alias yb="yarn build"
alias yd="yarn dev"

# pnpm aliases
alias pi="pnpm install"
alias pa="pnpm add"
alias pad="pnpm add --save-dev"
alias pr="pnpm run"
alias ps="pnpm start"
alias pt="pnpm test"
alias pb="pnpm run build"
alias pd="pnpm dev"

# =====================================================
# Git Aliases & Functions
# =====================================================

alias g="git"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"
alias gco="git checkout"
alias gch="git checkout"
alias gcb="git checkout -b"
alias gd="git diff"
alias gds="git diff --staged"
alias gf="git fetch"
alias gfa="git fetch --all"
alias gl="git log --oneline --graph --decorate"
alias gla="git log --oneline --graph --decorate --all"
alias gp="git push"
alias gpu="git push -u origin"
alias gpl="git pull"
alias gr="git rebase"
alias gri="git rebase -i"
alias gs="git status"
alias gst="git stash"
alias gstp="git stash pop"
alias gsh="git show"
alias grh="git reset --hard"
alias grs="git reset --soft"
alias gb="git branch"
alias gbd="git branch -d"
alias gbD="git branch -D"
alias gm="git merge"
alias gmor="git merge origin/release"

# Advanced git functions
gclone() { git clone "$1" && cd "$(basename "$1" .git)" }
gcom() { git add --all && git commit -m "$*" }
gpush() { git add --all && git commit -m "$*" && git push }

# =====================================================
# Utility Aliases & Functions
# =====================================================

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias -- -="cd -"

# File operations
alias ll="ls -la"
alias la="ls -la"
alias l="ls -l"
alias grep="grep --color=auto"
alias tree="tree -C"

# System
alias reload="source ~/.zshrc"
alias path='echo -e ${PATH//:/\\n}'
alias myip="curl -s ipinfo.io/ip"
alias ports="lsof -i -P -n | grep LISTEN"
alias df="df -h"
alias du="du -h"
alias free="top -l 1 -s 0 | grep PhysMem"

# File search and content
command -v rg >/dev/null 2>&1 && alias grep="rg --color=auto"

# Docker (if installed)
command -v docker >/dev/null 2>&1 && {
    alias d="docker"
    alias dc="docker-compose"
    alias dcu="docker-compose up"
    alias dcd="docker-compose down"
    alias dcb="docker-compose build"
    alias dps="docker ps"
    alias dpsa="docker ps -a"
    alias di="docker images"
    alias drm="docker rm"
    alias drmi="docker rmi"
    alias dprune="docker system prune -af"
}


# =====================================================
# Modern Development Tools
# =====================================================

# EZA - Modern replacement for ls
command -v eza >/dev/null 2>&1 && {
    alias ls="eza --color=always --group-directories-first"
    alias ll="eza -la --color=always --group-directories-first"
    alias la="eza -la --color=always --group-directories-first"
    alias l="eza -l --color=always --group-directories-first"
    alias lt="eza --tree --color=always --group-directories-first"
    alias l.="eza -dla .* --color=always --group-directories-first"
}

# Zoxide - Smarter cd command (lazy loaded for performance)
# Saves ~9ms on shell startup by only initializing when first used
if command -v zoxide >/dev/null 2>&1; then
    # Lazy load zoxide - only initialize when first used
    z() {
        unfunction z zi 2>/dev/null
        eval "$(zoxide init zsh)"
        z "$@"
    }
    zi() {
        unfunction z zi 2>/dev/null
        eval "$(zoxide init zsh)"
        zi "$@"
    }
    alias cd="z"
fi

# =====================================================
# Auto UV Environment - Intelligent Python Environment Management
# =====================================================
# 
# Using auto-uv-env tool for Python virtual environment management:
# - Detects Python projects via pyproject.toml
# - Extracts required Python version from project config
# - Auto-installs Python versions and creates venvs
# - Activates/deactivates environments on directory changes
#
# Tool: https://github.com/ashwch/auto-uv-env
# Performance: ~0ms for non-Python dirs, ~5-10ms for existing venvs
# One-time setup: 1-5 seconds for new environments
#
command -v auto-uv-env >/dev/null 2>&1 && {
    source /opt/homebrew/share/auto-uv-env/auto-uv-env.zsh
} || {
    # Fallback message if auto-uv-env is not installed
    auto_uv_env() {
        if [[ -f "pyproject.toml" ]]; then
            echo "auto-uv-env not found. Install with: brew install ashwch/tap/auto-uv-env" >&2
        fi
    }
}

# TheFuck removed - using ZSH's built-in correction (setopt CORRECT) instead

# HTTPie aliases
command -v http >/dev/null 2>&1 && {
    alias GET="http GET"
    alias POST="http POST"
    alias PUT="http PUT"
    alias DELETE="http DELETE"
}

# GitHub CLI aliases
command -v gh >/dev/null 2>&1 && {
    alias ghpr="gh pr create"
    alias ghprs="gh pr status"
    alias ghprv="gh pr view"
    alias ghrepo="gh repo view --web"
    alias ghissue="gh issue create"
}

# Better process monitor
command -v btop >/dev/null 2>&1 && alias top="btop"

# JSON/YAML processing aliases
command -v jq >/dev/null 2>&1 && alias jqp="jq -C . | less -R"
command -v yq >/dev/null 2>&1 && alias yqp="yq -C . | less -R"

# Tmux aliases
command -v tmux >/dev/null 2>&1 && {
    alias t="tmux"
    alias ta="tmux attach"
    alias tls="tmux list-sessions"
    alias tnew="tmux new-session -s"
}

# Directory shortcuts
alias dev="cd ~/Development"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias docs="cd ~/Documents"

# Quick editing
alias zshrc="$EDITOR ~/.zshrc"
alias hosts="sudo $EDITOR /etc/hosts"

# Secrets management
alias refresh-secrets='rm -f "$SECRETS_CACHE" && load_sops_secrets && echo "🔄 Secrets cache refreshed"'


# =====================================================
# Utility Functions
# =====================================================

# Make directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1" }

# Extract various archive formats
extract() {
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "'$1' cannot be extracted via extract()" ;;
    esac
}

# Find and kill process by name
killp() { ps aux | grep -v grep | grep "$1" | awk '{print $2}' | xargs kill -9 }

# Create and serve a simple HTTP server (removed duplicate)

# Weather function
weather() { curl -s "wttr.in/${1:-}" }

# QR code generator
qr() { curl -s "qrenco.de/$1" }

# Git file finder (renamed to avoid conflict with git fetch alias)
gitfind() { git ls-files | grep "$1" }

# Find and replace in files
findreplace() {
    if [[ $# -ne 3 ]]; then
        echo "Usage: findreplace <directory> <search> <replace>"
        return 1
    fi
    find "$1" -type f -exec sed -i '' "s/$2/$3/g" {} +
}

# JSON pretty print from clipboard (macOS)
jsonpp() { pbpaste | jq . | pbcopy }

# Create a backup of a file
backup() { cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)" }

# Quick HTTP server with specific port
serve() { 
    local port="${1:-8000}"
    echo "Starting server at http://localhost:$port"
    python3 -m http.server "$port"
}

# Git commit with conventional format
gconv() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: gconv <type> <message> [scope]"
        echo "Types: feat, fix, docs, style, refactor, test, chore"
        return 1
    fi
    local type="$1"
    local message="$2"
    local scope="$3"
    if [[ -n "$scope" ]]; then
        git commit -m "${type}(${scope}): ${message}"
    else
        git commit -m "${type}: ${message}"
    fi
}

# =====================================================
# Smart Alias Reminder System
# =====================================================


# Hook into the preexec function to check commands before execution
preexec() {
    # Get the full command line
    local full_cmd="$1"
    
    # Extract just the command part (before pipes, redirections, etc.)
    local cmd=$(echo "$full_cmd" | cut -d'|' -f1 | cut -d'>' -f1 | cut -d'<' -f1 | cut -d';' -f1 | xargs)
    
    # Simple case-based reminders (more reliable)
    case "$cmd" in
        "git status") echo "💡 Tip: You can use 'gs' instead of 'git status'" >&2 ;;
        "git add") echo "💡 Tip: You can use 'ga' instead of 'git add'" >&2 ;;
        "git add --all") echo "💡 Tip: You can use 'gaa' instead of 'git add --all'" >&2 ;;
        "git commit") echo "💡 Tip: You can use 'gc' instead of 'git commit'" >&2 ;;
        "git commit -m"*) echo "💡 Tip: You can use 'gcm' instead of 'git commit -m'" >&2 ;;
        "git push") echo "💡 Tip: You can use 'gp' instead of 'git push'" >&2 ;;
        "git pull") echo "💡 Tip: You can use 'gpl' instead of 'git pull'" >&2 ;;
        "git checkout") echo "💡 Tip: You can use 'gco' or 'gch' instead of 'git checkout'" >&2 ;;
        "git diff") echo "💡 Tip: You can use 'gd' instead of 'git diff'" >&2 ;;
        "git fetch") echo "💡 Tip: You can use 'gf' instead of 'git fetch'" >&2 ;;
        "git fetch --all") echo "💡 Tip: You can use 'gfa' instead of 'git fetch --all'" >&2 ;;
        "git merge origin/release") echo "💡 Tip: You can use 'gmor' instead of 'git merge origin/release'" >&2 ;;
        "git branch") echo "💡 Tip: You can use 'gb' instead of 'git branch'" >&2 ;;
        "git log --oneline --graph --decorate") echo "💡 Tip: You can use 'gl' instead of 'git log --oneline --graph --decorate'" >&2 ;;
        "npm install") echo "💡 Tip: You can use 'ni' instead of 'npm install'" >&2 ;;
        "npm run dev") echo "💡 Tip: You can use 'nd' instead of 'npm run dev'" >&2 ;;
        "npm run build") echo "💡 Tip: You can use 'nb' instead of 'npm run build'" >&2 ;;
        "npm run"*) echo "💡 Tip: You can use 'nr' instead of 'npm run'" >&2 ;;
        "npm start") echo "💡 Tip: You can use 'ns' instead of 'npm start'" >&2 ;;
        "npm test") echo "💡 Tip: You can use 'nt' instead of 'npm test'" >&2 ;;
        "docker ps") echo "💡 Tip: You can use 'dps' instead of 'docker ps'" >&2 ;;
        "docker-compose up") echo "💡 Tip: You can use 'dcu' instead of 'docker-compose up'" >&2 ;;
        "docker-compose down") echo "💡 Tip: You can use 'dcd' instead of 'docker-compose down'" >&2 ;;
        "tmux attach") echo "💡 Tip: You can use 'ta' instead of 'tmux attach'" >&2 ;;
        "tmux list-sessions") echo "💡 Tip: You can use 'tls' instead of 'tmux list-sessions'" >&2 ;;
        "uv run"*) echo "💡 Tip: You can use 'pyrun' instead of 'uv run'" >&2 ;;
        "ls -la") echo "💡 Tip: You can use 'll' instead of 'ls -la'" >&2 ;;
        "ls -l") echo "💡 Tip: You can use 'l' instead of 'ls -l'" >&2 ;;
    esac
}

# Show all available aliases by category
show_aliases() {
    echo "🚀 Available Aliases & Functions:"
    echo ""
    echo "📁 Navigation:"
    echo "  z <dir>     - Smart cd (zoxide)"
    echo "  ..          - cd .."
    echo "  ...         - cd ../.."
    echo "  fcd         - Fuzzy find directory"
    echo ""
    echo "📂 File Operations:"
    echo "  ls, ll, la  - Modern ls (eza)"
    echo "  lt          - Tree view"
    echo "  l.          - Show hidden files"
    echo "  grep        - Search (ripgrep)"
    echo ""
    echo "🐍 Python (UV):"
    echo "  pyrun       - uv run / uvx"
    echo "  pynew       - Create new project"
    echo "  pip         - uv pip"
    echo "  pipx        - uvx"
    echo "  venv        - uv venv"
    echo "  activate    - source .venv/bin/activate"
    echo ""
    echo "🌳 Git:"
    echo "  gs          - git status"
    echo "  ga          - git add"
    echo "  gaa         - git add --all"
    echo "  gc          - git commit"
    echo "  gcm         - git commit -m"
    echo "  gp          - git push"
    echo "  gpl         - git pull"
    echo "  gco         - git checkout"
    echo "  gd          - git diff"
    echo "  gl          - git log (pretty)"
    echo "  gconv       - Conventional commits"
    echo ""
    echo "📦 Node.js:"
    echo "  ni          - npm install"
    echo "  nr          - npm run"
    echo "  ns          - npm start"
    echo "  nd          - npm run dev"
    echo "  nt          - npm test"
    echo ""
    echo "🐳 Docker:"
    echo "  d           - docker"
    echo "  dc          - docker-compose"
    echo "  dcu         - docker-compose up"
    echo "  dcd         - docker-compose down"
    echo "  dps         - docker ps"
    echo ""
    echo "🖥️  Terminal:"
    echo "  t           - tmux"
    echo "  ta          - tmux attach"
    echo "  tls         - tmux list-sessions"
    echo "  reload      - source ~/.zshrc"
    echo "  fuck        - Fix last command"
    echo ""
    echo "🛠️  Alias Management:"
    echo "  alias_help  - Show alias management commands"
    echo "  add_alias   - Add new alias with auto-reminder"
    echo ""
    echo "⚡ Quick Utils:"
    echo "  serve       - HTTP server"
    echo "  weather     - Get weather"
    echo "  myip        - Get IP address"
    echo "  backup      - Backup file"
    echo "  extract     - Extract archives"
    echo "  gitfind     - Find files in git repo"
    echo ""
    echo "Type 'show_aliases' anytime to see this list!"
}

# =====================================================
# Alias Management & Validation Tools
# =====================================================

# Check which aliases are missing from reminder system
check_missing_reminders() {
    echo "🔍 Checking for aliases missing from reminder system..."
    echo ""
    
    local missing_count=0
    
    # Get all current aliases
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*alias[[:space:]]+([^=]+)=[\"\']*([^\"\']+)[\"\']*$ ]]; then
            local alias_name="${match[1]}"
            local alias_cmd="${match[2]}"
            
            # Check if this alias command is in our reminders
            if [[ -z "${ALIAS_REMINDERS[$alias_cmd]}" ]]; then
                echo "❌ Missing: '$alias_cmd' → '$alias_name'"
                ((missing_count++))
            fi
        fi
    done < ~/.zshrc
    
    if [[ $missing_count -eq 0 ]]; then
        echo "✅ All aliases are covered by the reminder system!"
    else
        echo ""
        echo "💡 Found $missing_count missing reminders. Consider adding them to the manual mappings in generate_alias_reminders()"
    fi
}

# Show all current reminders
show_reminders() {
    echo "🧠 Current Alias Reminders:"
    echo ""
    
    for cmd in "${(@k)ALIAS_REMINDERS}"; do
        echo "  '$cmd' → '${ALIAS_REMINDERS[$cmd]}'"
    done | sort
    
    echo ""
    echo "Total reminders: ${#ALIAS_REMINDERS[@]}"
}

# Add a new alias and automatically include it in reminders
add_alias() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: add_alias <alias_name> <command>"
        echo "Example: add_alias gf 'git fetch'"
        return 1
    fi
    
    local alias_name="$1"
    local command="$2"
    
    # Add the alias to .zshrc
    echo "" >> ~/.zshrc
    echo "# Added by add_alias function" >> ~/.zshrc
    echo "alias $alias_name=\"$command\"" >> ~/.zshrc
    
    # Reload the config to activate the alias
    source ~/.zshrc
    
    echo "✅ Added alias: $alias_name='$command'"
    echo "💡 Reminder system automatically updated!"
    echo "🔄 Config reloaded - alias is now active"
}

# Validate that all aliases work
validate_aliases() {
    echo "🧪 Validating all aliases..."
    echo ""
    
    local broken_count=0
    
    # Check each alias
    alias | while IFS= read -r alias_line; do
        if [[ "$alias_line" =~ ^([^=]+)=(.*)$ ]]; then
            local alias_name="${match[1]}"
            local alias_cmd="${match[2]}"
            
            # Remove quotes from command
            alias_cmd="${alias_cmd#[\"']}"
            alias_cmd="${alias_cmd%[\"']}"
            
            # Check if the underlying command exists (for simple commands)
            local base_cmd=$(echo "$alias_cmd" | awk '{print $1}')
            if ! command -v "$base_cmd" >/dev/null 2>&1 && ! type "$base_cmd" >/dev/null 2>&1; then
                echo "⚠️  Potentially broken: '$alias_name' → '$alias_cmd' (command '$base_cmd' not found)"
                ((broken_count++))
            fi
        fi
    done
    
    if [[ $broken_count -eq 0 ]]; then
        echo "✅ All aliases appear to be valid!"
    else
        echo ""
        echo "Found $broken_count potentially broken aliases. This might be normal for conditional aliases."
    fi
}

# Quick reference for alias management
alias_help() {
    echo "🛠️  Alias Management Commands:"
    echo ""
    echo "  show_aliases              - Show all aliases by category"
    echo "  show_reminders            - Show all current alias reminders"
    echo "  check_missing_reminders   - Find aliases not covered by reminders"
    echo "  add_alias <name> <cmd>    - Add new alias with auto-reminder"
    echo "  validate_aliases          - Check if all aliases work"
    echo "  generate_alias_reminders  - Regenerate reminder system"
    echo "  alias_help                - Show this help"
    echo ""
    echo "💡 The reminder system auto-updates when you reload your shell!"
}

# =====================================================
# ZSH Plugins (Direct Loading for Speed)
# =====================================================

# Syntax highlighting (load last)
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Autosuggestions
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    bindkey '^[[Z' autosuggest-accept  # Shift+Tab to accept suggestion
fi

# =====================================================
# Key Bindings
# =====================================================

# Emacs-style key bindings
bindkey -e

# History search (overridden by FZF if loaded)
# bindkey '^R' history-incremental-search-backward
# bindkey '^S' history-incremental-search-forward

# Word navigation
bindkey '^[[1;5C' forward-word    # Ctrl+Right
bindkey '^[[1;5D' backward-word   # Ctrl+Left

# Line editing
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^U' backward-kill-line
bindkey '^W' backward-kill-word

# =====================================================
# Starship Prompt (Load Last for Speed)
# =====================================================

eval "$(starship init zsh)"

# =====================================================
# Local Configuration
# =====================================================

# SOPS Secrets Management
# Provides automatic loading of encrypted secrets with performance caching
# Cache TTL: 5 minutes (configurable via SECRETS_CACHE_TTL)
SECRETS_CACHE="/tmp/.sops_cache_${UID}"
SECRETS_CACHE_TTL=300

# Load encrypted secrets from SOPS with intelligent caching
load_sops_secrets() {
    # Check cache validity
    if [[ -f "$SECRETS_CACHE" ]]; then
        local cache_mod_time=$(stat -f %m "$SECRETS_CACHE" 2>/dev/null || stat -c %Y "$SECRETS_CACHE" 2>/dev/null || echo 0)
        local cache_age=$(($(date +%s) - cache_mod_time))
        
        if [[ $cache_age -lt $SECRETS_CACHE_TTL ]]; then
            source "$SECRETS_CACHE"
            return 0
        fi
    fi
    
    # Decrypt secrets first, and only proceed if successful
    local decrypted_yaml
    decrypted_yaml=$(cd ~/dotfiles && sops -d .secrets.yaml 2>/dev/null)

    # Exit if decryption failed, preventing cache corruption. The last valid cache will be used.
    if [[ $? -ne 0 ]] || [[ -z "$decrypted_yaml" ]]; then
        echo "SOPS Error: Failed to decrypt secrets. Using last known values if available." >&2
        return 1
    fi

    # If decryption is successful, parse with yq
    local secrets_export
    secrets_export=$(echo "$decrypted_yaml" | yq e '. | to_entries | .[] | "export " + .key + "=\"" + .value + "\""' - 2>/dev/null)

    # Exit if parsing failed
    if [[ $? -ne 0 ]] || [[ -z "$secrets_export" ]]; then
        echo "SOPS Error: Failed to parse secrets with yq. Check .secrets.yaml format." >&2
        return 1
    fi

    # If both steps succeed, update the cache and apply to the current shell
    echo "$secrets_export" > "$SECRETS_CACHE"
    chmod 600 "$SECRETS_CACHE"
    eval "$secrets_export"
}

# Initialize secrets if all dependencies are available
if command -v sops &>/dev/null && \
   command -v yq &>/dev/null && \
   [[ -f ~/dotfiles/.secrets.yaml ]] && \
   [[ -f ~/.config/sops/age/keys.txt ]]; then
    load_sops_secrets
fi



# Load work-specific configuration if it exists  
[[ -f ~/.zshrc.work ]] && source ~/.zshrc.work

# =====================================================
# FZF Configuration (Load Last)
# =====================================================

# FZF setup - load key bindings and completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border
    --multi
    --preview "bat --style=numbers --color=always --line-range :500 {}"
    --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
    --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
    --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
    --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# FZF utility functions
fcd() { cd "$(fd --type d | fzf)" }
fvim() { $EDITOR "$(fzf)" }
fkill() { ps aux | fzf | awk '{print $2}' | xargs kill -9 }

# =====================================================
# WeasyPrint Library Path Fix
# =====================================================

# Fix for WeasyPrint with UV's isolated Python environment
export DYLD_FALLBACK_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_FALLBACK_LIBRARY_PATH"

. /opt/homebrew/opt/asdf/libexec/asdf.sh
