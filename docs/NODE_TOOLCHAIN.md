# Node Toolchain

This repo uses **standalone pnpm** to install and manage Node.js.

The goal is simple:

```text
one tool installs Node
one PATH location exposes Node
no Homebrew Node / pnpm / nvm required
```

## Mental model

When a zsh process starts, command lookup works from left to right through `PATH`:

```text
zsh starts
  ↓
~/.zshenv runs for every zsh shell
  ↓
PNPM_HOME=$HOME/.local/share/pnpm
  ↓
PATH starts with $PNPM_HOME/bin
  ↓
node, pnpm, pnpx, pi, etc. are found there first
```

That means a fresh shell should resolve tools like this:

```bash
command -v node
# /Users/<you>/.local/share/pnpm/bin/node

command -v pnpm
# /Users/<you>/.local/share/pnpm/bin/pnpm
```

## Bootstrap flow

`setup.sh` does the bootstrap in this order:

```text
curl get.pnpm.io/install.sh
  ↓
installs standalone pnpm into $PNPM_HOME
  ↓
pnpm runtime set node lts -g
  ↓
installs/switches the global Node runtime managed by pnpm
```

Equivalent manual commands:

```bash
export PNPM_HOME="$HOME/.local/share/pnpm"
curl -fsSL https://get.pnpm.io/install.sh | \
  env PNPM_VERSION=11.1.3 PNPM_HOME="$PNPM_HOME" SHELL=/bin/zsh sh -
export PATH="$PNPM_HOME/bin:$PATH"
pnpm runtime set node lts -g
```

## Why not Homebrew pnpm, Homebrew Node, or nvm?

First principles:

```text
Homebrew pnpm is a Node script
  ↓
#!/usr/bin/env node
  ↓
it needs Node before it can run
```

That creates a bootstrap loop if our goal is "pnpm manages Node".

`nvm` also needs interactive shell setup and a shell function. That is useful in some workflows, but it makes non-interactive scripts and agent sessions less predictable.

So this repo intentionally avoids:

```text
brew "node"
brew "pnpm"
brew "nvm"
~/.nvm
```

## Files that own the behavior

| File | What it owns | Why |
|------|--------------|-----|
| `.zshenv` | `PNPM_HOME` and PATH order | Runs in every zsh shell, including scripts and agents |
| `.zshrc` | npm/yarn muscle-memory aliases | Interactive convenience only; it does not install tools |
| `setup.sh` | standalone pnpm bootstrap + `pnpm runtime set node lts -g` | Makes a fresh machine reproducible |
| `Brewfile` | Homebrew packages excluding Node/pnpm/nvm | Avoids Homebrew owning Node |

## Alias translation table

The aliases are just shortcuts. They do **not** reintroduce npm or yarn binaries.

```text
old habit                 actual command
────────────────────────────────────────────
ni                        pnpm install
nid                       pnpm add --save-dev
nig                       pnpm add --global
nr                        pnpm run
nd                        pnpm dev
nb                        pnpm run build

npx eslint .              pnpm exec eslint .
npx create-vite           pnpm dlx create-vite
npm install -g <package>  pnpm add -g <package>
```

## Switching Node versions

Use pnpm runtime directly:

```bash
pnpm runtime set node lts -g
pnpm runtime set node 22 -g
pnpm runtime set node 24.16.0 -g
```

This switch is global. Project files like `.nvmrc` can still be useful as hints, but they do not require nvm.

## Verification

Run this after setup or after changing PATH-related files:

```bash
zsh -c '
for c in node pnpm pnpx npm npx yarn corepack nvm; do
  printf "%-12s" "$c:"
  command -v "$c" || true
done
node -v
pnpm -v
'
```

Expected shape:

```text
node:       ~/.local/share/pnpm/bin/node
pnpm:       ~/.local/share/pnpm/bin/pnpm
pnpx:       ~/.local/share/pnpm/bin/pnpx
npm:        <empty>
npx:        <empty>
yarn:       <empty>
corepack:   <empty>
nvm:        <empty>
```

## About the generated `# pnpm` shell block

The pnpm installer normally appends this block to a shell file:

```sh
# pnpm
export PNPM_HOME="..."
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
```

In this repo, `.zshenv` owns that job instead.

Why we remove the generated block in `setup.sh`:

```text
~/.zshrc may be a symlink to ~/dotfiles/.zshrc
  ↓
pnpm installer appends generated text to ~/.zshrc
  ↓
the public repo file gets mutated by a machine-local installer
  ↓
future setup runs become noisy and hard to reason about
```

If the generated block appears, remove it and keep PATH setup in `.zshenv`.
