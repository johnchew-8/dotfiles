# Dotfiles Migration Plan

## Motivation

- [Stow issue #134](https://github.com/aspiers/stow/issues/134): `--dotfiles` flag
  produces broken results when target directories don't already exist (creates
  directories with literal `dot-` prefix instead of symlinking with `.` prefix).
- Stow appears unmaintained; [Tuckr](https://github.com/RaphGL/Tuckr) is a
  modern, actively maintained replacement with the same symlinking model.

## High-Level Overview

```
Phase 1: Restructure to conventional per-app layout (still using stow)
Phase 2: Wrap in Configs/ and switch from stow to tuckr
```

Both phases use literal `.` prefixes — the `dot-` convention is dropped entirely.

---

## Phase 1 — Restructure to conventional per-app layout

### Target Structure

```
~/.dotfiles/                          # repo (renamed from ~/dotfiles)
├── alacritty/
│   └── .config/alacritty/
│       └── alacritty.toml
├── bash/
│   ├── .bashrc
│   └── .profile
├── eza/
│   └── .config/eza/
│       └── (theme files)
├── fish/
│   └── .config/fish/
│       └── config.fish, conf.d/, functions/, completions/
├── git/
│   └── .config/git/
│       ├── config
│       └── config-windows
├── nvim/
│   └── .config/nvim/
│       └── init.lua, lua/, lazy-lock.json, .stylua.toml
├── tmux/
│   └── .config/tmux/
│       ├── tmux.conf
│       └── plugins/
│           └── tpm/                  # git submodule
├── zellij/
│   └── .config/zellij/
│       ├── config.kdl
│       ├── layouts/default.kdl
│       └── plugins/.gitkeep
├── .gitignore
├── .gitmodules
├── .stowrc                            # --verbose --target=$HOME (no --dotfiles)
├── makefile                           # stale — not used during migration
├── plan.md
└── README.md
```

### Stow invocation (Phase 1)

```
stow -d $HOME -t $HOME {group}
```

Per-group deployment, Tuckr-aligned. Example:

```bash
stow -t $HOME bash        # deploys ~/.bashrc and ~/.profile
stow -t $HOME nvim        # deploys ~/.config/nvim/
stow -t $HOME -D bash     # removes bash group symlinks
```

### .stowrc (Phase 1)

```
--verbose
--target=$HOME
```

No `--dotfiles` — all files already use their literal `.` prefixed names.

### Decision Summary

| Decision | Choice |
|----------|--------|
| Directory layout | `{app}/.config/{app}/` for XDG dirs, `bash/.bashrc` for home files |
| bash/profile grouping | Combined into `bash/` group |
| `dot-` prefix | Dropped — literal `.` prefix throughout |
| `.stowrc` | `--verbose` + `--target=$HOME` only |
| `.stow-local-ignore` | Removed (stow's `-d Configs` scoping makes it unnecessary) |
| `.gitignore` | Rewrite all `dot-config/` paths → `{app}/.config/{app}/` |
| Stow invocation | Per-group: `stow -d $HOME -t $HOME {group}` |
| makefile | Stale, not used during Phase 1 |
| Repo path | `~/.dotfiles` (rename from `~/dotfiles`) |
| Submodule (tmux/tpm) | `git mv` to preserve submodule metadata |

### Execution Order

#### Step 1: Unstow all current symlinks

Run these with the **current** `.stowrc` and `.stow-local-ignore` still in place:

```bash
cd ~/dotfiles
stow -D .                                       # unstow home files (.bashrc, .profile)
stow -d dot-config -t ~/.config -D              # unstow .config entries
```

Verify nothing is left:

```bash
ls -la ~/.bashrc ~/.profile                     # should not exist (or be regular files)
ls -la ~/.config/{alacritty,eza,git,nvim}       # should not exist (or be real dirs)
```

#### Step 2: Rename repo directory

```bash
mv ~/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

#### Step 3: Restructure files

Create the per-app group directories and move files. Order: non-submodule first,
submodule last.

```bash
# --- bash (home-level files) ---
mkdir -p bash
mv dot-bashrc bash/.bashrc
mv dot-profile bash/.profile

# --- XDG config apps ---
# alacritty
mkdir -p alacritty/.config
mv dot-config/alacritty alacritty/.config/alacritty

# eza
mkdir -p eza/.config
mv dot-config/eza eza/.config/eza

# fish
mkdir -p fish/.config
mv dot-config/fish fish/.config/fish

# git
mkdir -p git/.config
mv dot-config/git git/.config/git

# nvim
mkdir -p nvim/.config
mv dot-config/nvim nvim/.config/nvim

# tmux (non-submodule files first)
mkdir -p tmux/.config/tmux
mv dot-config/tmux/tmux.conf tmux/.config/tmux/

# tmux submodule via git mv
git mv dot-config/tmux/plugins tmux/.config/tmux/plugins

# zellij
mkdir -p zellij/.config
mv dot-config/zellij zellij/.config/zellij

# Remove the now-empty dot-config directory
rmdir dot-config/tmux 2>/dev/null || true      # tmux.conf was moved
rmdir dot-config 2>/dev/null || true            # should be empty now
```

At this point the file tree matches the target structure above.

#### Step 4: Update .gitignore paths

Replace `dot-config/{app}/` with `{app}/.config/{app}/`:

```diff
 # Tmux
-dot-config/tmux/plugins/*
-!dot-config/tmux/plugins/tpm
+tmux/.config/tmux/plugins/*
+!tmux/.config/tmux/plugins/tpm

 # Fish
-dot-config/fish/config.local.fish
-dot-config/fish/fish_variables
-dot-config/fish/fish_history
-dot-config/fish/conf.d/*
-dot-config/fish/functions/*
-dot-config/fish/completions/*
+fish/.config/fish/config.local.fish
+fish/.config/fish/fish_variables
+fish/.config/fish/fish_history
+fish/.config/fish/conf.d/*
+fish/.config/fish/functions/*
+fish/.config/fish/completions/*

-!dot-config/fish/functions/eza.fish
-!dot-config/fish/functions/agent_load.fish
-!dot-config/fish/functions/rfnvim.fish
-!dot-config/fish/functions/cat.fish
+!fish/.config/fish/functions/eza.fish
+!fish/.config/fish/functions/agent_load.fish
+!fish/.config/fish/functions/rfnvim.fish
+!fish/.config/fish/functions/cat.fish

 # Zellij
-dot-config/zellij/plugins/*
-!dot-config/zellij/plugins/.gitkeep
+zellij/.config/zellij/plugins/*
+!zellij/.config/zellij/plugins/.gitkeep
```

#### Step 5: Update .stowrc and remove .stow-local-ignore

Edit `.stowrc` — remove `--dotfiles` line:

```
--verbose
--target=$HOME
```

Delete `.stow-local-ignore`:

```bash
rm .stow-local-ignore
```

#### Step 6: Verify Phase 1 with stow

```bash
# Deploy all groups
stow -t $HOME bash alacritty eza fish git nvim tmux zellij

# Verify symlinks exist
ls -la ~/.bashrc ~/.profile
ls -la ~/.config/alacritty ~/.config/nvim ~/.config/tmux

# Check status (should show no conflicts)
stow -t $HOME --no alacritty 2>&1 || true
```

#### Step 7: Commit

```bash
git add -A
git status                     # review before committing
git commit -m "Phase 1: restructure to conventional per-app layout"
```

---

## Phase 2 — Tuckr Migration

### Target Structure

```
~/.dotfiles/
├── Configs/                            # tuckr groups live here
│   ├── alacritty/
│   │   └── .config/alacritty/...
│   ├── bash/
│   │   ├── .bashrc
│   │   └── .profile
│   ├── eza/
│   │   └── .config/eza/...
│   ├── fish/
│   │   └── .config/fish/...
│   ├── git/
│   │   └── .config/git/...
│   ├── nvim/
│   │   └── .config/nvim/...
│   ├── tmux/
│   │   └── .config/tmux/...
│   └── zellij/
│       └── .config/zellij/...
├── Hooks/                              # optional, currently empty
├── Secrets/                            # skip — not needed
├── .gitignore
├── .gitmodules
├── makefile                            # to be rewritten for tuckr commands
├── plan.md
└── README.md
```

### Tuckr commands

```bash
tuckr add \*              # deploy all groups
tuckr add nvim            # deploy single group
tuckr add \* -e tmux      # deploy all except tmux
tuckr rm \*               # remove all symlinks
tuckr status              # show symlinking status
```

### Decision Summary

| Decision | Choice |
|----------|--------|
| Dotfiles location | `~/.dotfiles` (tuckr standard path) |
| Secrets | Not used |
| Hooks | Optional, empty for now |
| `.stowrc` | Removed entirely (tuckr needs no config) |
| makefile | Rewrite for `tuckr` commands |
| `.gitignore` paths | Prepend `Configs/` to all Phase 1 paths |
| git clone on fresh machine | `git clone <url> ~/.dotfiles` |

### Execution Order

#### Step 1: Unstow Phase 1 symlinks

```bash
cd ~/.dotfiles
stow -t $HOME -D bash alacritty eza fish git nvim tmux zellij
```

#### Step 2: Remove stale files

```bash
rm .stowrc
```

#### Step 3: Wrap groups in Configs/

```bash
mkdir -p Configs
mv alacritty bash eza fish git nvim tmux zellij Configs/
```

If Tuckr hooks are desired later:

```bash
mkdir -p Hooks
```

#### Step 4: Update .gitignore paths

Prepend `Configs/` to all group paths:

```diff
-tmux/.config/tmux/plugins/*
-!tmux/.config/tmux/plugins/tpm
+Configs/tmux/.config/tmux/plugins/*
+!Configs/tmux/.config/tmux/plugins/tpm

-fish/.config/fish/config.local.fish
+Configs/fish/.config/fish/config.local.fish
 ... (same pattern for all entries)
```

#### Step 5: Deploy with tuckr

```bash
tuckr add \*
tuckr status                  # verify all groups are deployed
```

#### Step 6: Rewrite makefile

Replace stow commands with tuckr equivalents:

```makefile
.PHONY: help install restow

help:
	@echo "--- tuckr dotfiles ---"
	@echo "  tuckr add \*         Deploy all groups"
	@echo "  tuckr rm \*          Remove all symlinks"
	@echo "  tuckr status         Show status"

install:
	tuckr add \*

restow:
	tuckr rm \*
	tuckr add \*
```

#### Step 7: Commit

```bash
git add -A
git status
git commit -m "Phase 2: migrate from stow to tuckr"
```

---

## Tuckr Compatibility Notes

### Ignore mechanism

Tuckr has no built-in ignore file (feature request open:
[#150](https://github.com/RaphGL/Tuckr/issues/150)). The maintainer suggests
`tuckr add <group> --only-files` as a workaround. In practice this is not
an issue because:

1. `.gitignore` prevents unwanted files from being committed
2. Tuckr is scoped to `Configs/` — repo metadata is invisible
3. Editor artifacts (`.swp`, `.bak`) only exist transiently during editing

If a `.tuckrignore` feature lands in future, that's the Phase 3 answer.

### git clone on fresh machines

The remote is named `dotfiles` but clones to `~/.dotfiles` via the explicit
target directory:

```bash
git clone git@github.com:user/dotfiles.git ~/.dotfiles
```

This satisfies Tuckr's `$HOME/.dotfiles` lookup. No rename needed.

### Submodule

The tmux/tpm submodule path survives Phase 2 unchanged:
`Configs/tmux/.config/tmux/plugins/tpm`. The `.gitmodules` entry was already
updated by `git mv` in Phase 1 — Phase 2 only wraps with `Configs/`, which
does not affect submodule tracking.

### fish/tmux/zellij real-dir divergence

After the execution plan is written, diff the real `~/.config/{fish,tmux,zellij}`
directories against their corresponding groups in the repo. These may have
runtime-generated or machine-local content that needs to be captured or
explicitly excluded before the first `tuckr add`.
