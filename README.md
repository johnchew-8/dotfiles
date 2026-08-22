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

### Fisher plugin manager:

[Install fisher](https://github.com/jorgebucaran/fisher)
Then install plugins from the tracked list:

```fish
fisher install
fisher update
```

Install [fzf.fish](https://github.com/PatrickF1/fzf.fish), [nvm.fish](https://github.com/jorgebucaran/nvm.fish)

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

### Zellij (zjstatus plugin)

Download the plugin into the plugins dir (one-time):

```fish
curl -fL -o ~/.dotfiles/Configs/zellij/.config/zellij/plugins/zjstatus.wasm \
  https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm
```
