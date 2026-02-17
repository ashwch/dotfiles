#!/bin/bash
# Tab completion for the `peon` CLI alias (peon-ping quick controls).
#
# Provides completions for: peon --pause, --resume, --pack <name>, etc.
#
# WHY bashcompinit IS LOADED FIRST
# ---------------------------------
# This file uses bash's `complete` builtin (line 51). In zsh, `complete`
# doesn't exist unless bashcompinit is loaded first. The upstream version
# had bashcompinit AFTER the first `complete` call, which caused:
#
#   completions.bash:28: command not found: complete
#
# Moving bashcompinit to the top fixes this. It's a no-op in bash.
#
# SOURCED FROM
# ------------
# .zshrc loads this file:
#   [ -f ~/.claude/hooks/peon-ping/completions.bash ] && source ...
# That path is a symlink → dotfiles/.config/peon-ping/completions.bash

# zsh compatibility: enable bashcompinit before any `complete` calls
if [ -n "$ZSH_VERSION" ]; then
  autoload -Uz bashcompinit 2>/dev/null && bashcompinit
fi

_peon_completions() {
  local cur prev opts packs_dir
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  # Top-level options
  opts="--pause --resume --toggle --status --packs --pack --help"

  if [ "$prev" = "--pack" ]; then
    # Complete pack names by scanning manifest files
    packs_dir="${CLAUDE_PEON_DIR:-$HOME/.claude/hooks/peon-ping}/packs"
    if [ -d "$packs_dir" ]; then
      local names
      names=$(find "$packs_dir" -maxdepth 2 -name manifest.json -exec dirname {} \; 2>/dev/null | xargs -I{} basename {} | sort)
      COMPREPLY=( $(compgen -W "$names" -- "$cur") )
    fi
    return 0
  fi

  COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
  return 0
}

complete -F _peon_completions peon
