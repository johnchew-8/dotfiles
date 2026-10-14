# pnpm
export PNPM_HOME='/Users/johnc/.local/share/pnpm'
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
# mise: manages java/maven, sets JAVA_HOME per directory
command -v mise >/dev/null && eval "$(mise activate zsh)"

# Clear screen but keep scrollback (macOS clear sends \e[3J which wipes it)
clear() { printf '\n%.0s' {1..$LINES}; printf '\e[H\e[2J'; }
