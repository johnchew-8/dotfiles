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
- [`gh` (GitHub CLI)](https://github.com/cli/cli) — handles git authentication over HTTPS (`gh auth login`)

## New device setup

Clone the repo

```fish
cd ~/.dotfiles
make install
```

`make install` deploys all symlinks via Tuckr. It does not install plugins - see below.

## Adding a new dotfile

Layout: `Configs/<group>/.config/<app>/` for XDG apps, `Configs/<group>/` for home-directory files (`.bashrc`, `.profile`).

1. Place file in the matching group using `mv`
2. Run `make install` to symlink
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

