# =====================================================
# Global Zsh Environment (non-interactive too)
#
# This file is sourced by every zsh instance (login,
# interactive, and non-interactive). Keep it focused on
# pure environment setup and PATH configuration.
# =====================================================

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Language & Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Default Programs
export EDITOR="code"       # Preferred editor
export VISUAL="code"       # Preferred visual editor
export BROWSER="open"      # macOS default browser launcher

# PATH configuration
# Use the zsh-specific path array to avoid duplicates and
# make ordering explicit. "typeset -U" keeps entries unique.
typeset -U path PATH        # Deduplicate PATH while preserving order
path=(
  /opt/homebrew/bin
  /opt/homebrew/sbin
  $HOME/.local/bin
  $HOME/dotfiles/bin
  /opt/homebrew/opt/postgresql@17/bin
  $path
)
export PATH

# Tool-specific PATH additions that should be available in
# all shells (interactive and non-interactive).
path+=(
  $HOME/.lmstudio/bin           # LM Studio CLI
  $HOME/.antigravity/antigravity/bin  # Antigravity virtualenv
)

# Python / cryptography diagnostics in all zsh contexts
export PYTHONFAULTHANDLER=1             # Show Python fault tracebacks
export RQ_WORKER_CLASS=rq.SimpleWorker   # Default RQ worker class
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 # Disable legacy OpenSSL
export PYTHONTRACEMALLOC=1              # Track Python allocations

# Library path fix needed for WeasyPrint when using UV's
# isolated Python environment.
export DYLD_FALLBACK_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_FALLBACK_LIBRARY_PATH"

