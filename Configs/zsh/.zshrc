# fish is daily shell, zsh is kept for tools that run it, like claude
export PNPM_HOME="$HOME/.local/share/pnpm"

# First prefix found wins
if [[ -z ${HOMEBREW_PREFIX-} ]]; then
  for brew_prefix in /home/linuxbrew/.linuxbrew /opt/homebrew /usr/local; do
    if [[ -x $brew_prefix/bin/brew ]]; then
      eval "$("$brew_prefix/bin/brew" shellenv zsh)"
      break
    fi
  done
  unset brew_prefix
fi

_dotfiles_path() {
  typeset -gU path
  local -a user_dirs=(
    $HOME/.local/bin
    $HOME/.cargo/bin
    $HOME/.docker/bin
    $HOME/.pixi/bin
    $HOME/.bun/bin
    $HOME/.local/share/fzf/bin
    $HOME/go/bin
    $PNPM_HOME/bin
  )
  path=($^user_dirs(N-/) $path)
  [[ -n ${HOMEBREW_PREFIX-} ]] && path=($HOMEBREW_PREFIX/bin $HOMEBREW_PREFIX/sbin $path)
  # Non-interactive shells get mise shims; interactive shells use mise activate in .zshrc.
  if [[ ! -o interactive ]] && (( $+commands[mise] )); then
    path=($HOME/.local/share/mise/shims $path)
  fi
}
_dotfiles_path