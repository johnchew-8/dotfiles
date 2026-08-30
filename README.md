# dotfiles

dotfiles tracked using Tuckr. Makes my terminal look kewl.

## Prerequisites

Install via appropriate package manager, ideally get latest version:

- [`Tuckr`](https://github.com/RaphGL/Tuckr)
- [`tmux`](https://github.com/tmux/tmux)
- [`fish` (3.6+)](https://github.com/fish-shell/fish-shell)
- [`nvim`](https://github.com/neovim/neovim)
- [`zellij`](https://github.com/zellij-org/zellij)
- [`fzf`](https://github.com/junegunn/fzf)
- [`bat`](https://github.com/sharkdp/bat)
- [`eza`](https://github.com/eza-community/eza)
- [`fd`](https://github.com/sharkdp/fd)
- [`git-delta`](https://github.com/dandavison/delta)
- [`gh`](https://github.com/cli/cli)

## New device setup

Clone the repo

```fish
cd ~/.dotfiles
make deploy
```

`make deploy` deploys all symlinks via Tuckr. It does not install plugins - see below.

## Profiles (personal vs work)

Tuckr [profiles](https://raphgl.github.io/Tuckr/fundamentals/profiles.html) keep a second, private dotfiles repo (`dotfiles_work`) alongside this one on the work machine. This repo is the **default** profile; the work profile lives at `~/.dotfiles_work` and deploys with the `work` flag.

```fish
tuckr ls profiles         # lists: work (when ~/.dotfiles_work exists)
make deploy               # deploy default profile (this repo)
make deploy-work          # deploy work profile (~/.dotfiles_work)
make restow-work          # redeploy work profile
tuckr -p work status      # inspect work profile symlinks
```

Rules that keep both profiles conflict-free:

- The work repo may only contain paths this repo does not own (e.g. it owns `~/.config/git/config-work`, never `~/.config/git/config`). Two profiles never merge file contents.
- Shared behavior stays single-sourced here on `main`; the work repo holds work-only deltas.
- Per-machine tweaks belong in `~/.config/fish/config.local.fish` (untracked, sourced by `config.fish`).

### Work git identity

This repo's git config includes the optional file `~/.config/git/config-work`:

```git
[include]
	path = ~/.config/git/config-work
```

Git silently skips missing includes, so the same config works on both machines: personal machines have no `config-work`; the work profile deploys it with the work `[user]` identity, overriding the one above.

## Adding a new dotfile

Layout: `Configs/<group>/.config/<app>/` for XDG apps, `Configs/<group>/` for home-directory files (`.bashrc`, `.profile`).

1. Place file in the matching group using `mv`
2. Run `make deploy` to symlink
3. Commit

## Per-tool setup

### Git delta

Git is configured to use `delta` as its pager. Install with `cargo install git-delta` or with distribution's package manager and ensure `delta` is added to path.

### Fisher plugin manager:

```fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher update   # installs plugins from tracked fish_plugins
```

Plugins tracked in [`fish_plugins`](Configs/fish/.config/fish/fish_plugins): [fzf.fish](https://github.com/PatrickF1/fzf.fish), [nvm.fish](https://github.com/jorgebucaran/nvm.fish)

### Fish (secrets):

```fish
# Edit and add your own API keys / tokens - for agentic code
$EDITOR ~/.config/fish/config.local.fish
```

### tmux (tpm plugins):

Open tmux, press `prefix + I` to install plugins via tpm. To resync:

```fish
cd ~/.dotfiles
make restow
```

Note: tmux launches `fish` from `PATH` (no hardcoded shell path), so fish must be on `PATH` before starting tmux.
