function clear
      printf '\n%.0s' (seq $LINES)
      printf '\e[H\e[2J'
end