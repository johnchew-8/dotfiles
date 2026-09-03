# dotfiles

dotfiles tracked using Tuckr. Makes my terminal look kewl.

## Prerequisites

CLI prerequisites are managed with [Homebrew](https://brew.sh) via the committed [`Brewfile`](Brewfile) - source of truth for the tool list:

```fish
make cli-tools
```

`make cli-tools` locates `brew` across the standard prefixes (`/opt/homebrew`, `/usr/local`, `/home/linuxbrew/.linuxbrew`) and runs `brew bundle install`. It is idempotent - safe to re-run on existing machines, anything already installed is skipped.


> Linux: Homebrew's installer requires a `sudo` password with `build-essential`, `curl` and `git` preinstalled. Not supported on Alpine/musl.

## New device setup

Clone the repo

```fish
cd ~/.dotfiles
make bootstrap
```

`make bootstrap` installs the CLI prerequisites via Homebrew (`make cli-tools`) and then deploys all symlinks (`make deploy`). Both steps are idempotent - safe to re-run. Plugins are not installed - see below.

## Profiles (personal vs work)

Tuckr [profiles](https://raphgl.github.io/Tuckr/fundamentals/profiles.html) keep private dotfiles repo (`dotfiles_work`) alongside this one on the work machine. This repo is the **default** profile; the work profile lives at `~/.dotfiles_work` and deploys with the `work` flag.

On the work machine, both profiles must be deployed together: `make deploy` + `make deploy-work`.

```fish
tuckr ls profiles         # lists: work (when ~/.dotfiles_work exists)
make deploy               # deploy default profile (this repo)
make deploy-work          # deploy work profile (~/.dotfiles_work)
make restow-work          # redeploy work profile
tuckr -p work status      # inspect work profile symlinks
```

Rules that keep both profiles conflict-free:

- The work repo may only contain paths this repo does not own (e.g. it owns `~/.config/git/config-work`, **NOT** `~/.config/git/config`). Two profiles never merge file contents.
- Shared behavior stays single-sourced here on `main`; the work repo holds work-only deltas.
- Per-machine tweaks belong in `~/.config/fish/config.local.fish` (untracked, sourced by `config.fish`).

## Adding a new dotfile

Layout: `Configs/<group>/.config/<app>/` for XDG apps, `Configs/<group>/` for home-directory files (`.bashrc`, `.profile`).

1. Place file in the matching group using `mv`
2. Run `make deploy` to symlink
3. Commit

## Per-tool setup

### Git delta

Git is configured to use `delta` as its pager. It is installed via the Brewfile (`make cli-tools`); the brew binary wins on `PATH`.

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
