# mise
(( $+commands[mise] )) && eval "$(mise activate zsh)"

# Clear screen but keep scrollback
clear() { printf '\n%.0s' {1..$LINES}; printf '\e[H\e[2J'; }