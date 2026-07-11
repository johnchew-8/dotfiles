# dotfiles

dotfiles tracked using stow. Makes my terminal look kewl.

## Prerequisites

Install via appropriate package manager, ideally get latest version:

- [`Tuckr`](https://github.com/RaphGL/Tuckr)
- [`tmux`](https://github.com/tmux/tmux)
- [`fish` (3.6+)](https://github.com/fish-shell/fish-shell)
- [`nvim`](https://github.com/neovim/neovim)
- [`zellij`](https://github.com/zellij-org/zellij)
- [`fzf`](https://github.com/junegunn/fzf)
- [`bat`](github.com/sharkdp/bat)
- [`eza`](https://github.com/eza-community/eza)
- [`fd`](https://github.com/sharkdp/fd)

## New device setup

Clone the repo

```fish
cd ~/dotfiles
make install
```

make install deploys symlinks and initializes submodules in this repo. **It does not** install plugins — see below.

Run `make install` (which stows) **before** launching the relevant tool on a fresh machine. Otherwise, the tool may auto-create a default config on first start.

## Adding a new dotfile

**TODO**: Conventional directory structure and Tuckr migration.

~~Use following stow sequence to prevent top-level artifacts in $HOME

**From `~/.config/`**

```fish
mv ~/.config/<app> ~/dotfiles/dot-config/<app>
cd ~/dotfiles
make stow-config
```

**From `$HOME`**:

```fish
# The dot- prefix is required — stow's --dotfiles strips it at link time
mv ~/.somefile ~/dotfiles/dot-somefile
cd ~/dotfiles
make stow-home
```

> After running `make stow-config`, verify with `readlink -f ~/.config/<app>` — it should resolve to `~/dotfiles/dot-config/<app>`.~~

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
$EDITOR ~/.config/fish/config.local.fisher
```

### tmux (tpm plugins):

Open tmux, press prefix + I. Installs tpm

```fish
cd ~/dotfiles
make update-submodules # refresh tpm
make restow # re-link any new/changed files
```

### Zellij (zjstatus plugin)

Download the plugin into the plugins dir (one-time):

```fish
curl -fL -o ~/dotfiles/dot-config/zellij/plugins/zjstatus.wasm \
  https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm
```
