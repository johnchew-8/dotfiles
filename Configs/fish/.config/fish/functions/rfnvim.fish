function rfnvim --description 'Live ripgrep search; open matches in nvim'
    set -l q (string join ' ' -- $argv)
    # Runs under `sh -c` (see --with-shell), POSIX syntax only in these strings.
    set -l rg_cmd "rg --column --color=always --smart-case --hidden --glob '!.git/'"
    set -l reload "reload:[ -n {q} ] && $rg_cmd -- {q} || true"
    set -l opener 'if [ "$FZF_SELECT_COUNT" -eq 0 ]; then nvim +"call cursor({2},{3})" -- {1}; else nvim +cw -q {+f}; fi'

    fzf --with-shell 'sh -c' \
        --disabled --ansi --multi \
        --prompt 'rfnvim> ' \
        --header 'enter: open | tab: mark | ctrl-f: filter | ctrl-r: rg | ctrl-/: preview' \
        --bind "start:$reload" \
        --bind "change:$reload" \
        --bind "enter:become:$opener" \
        --bind "ctrl-o:execute:$opener" \
        --bind 'ctrl-f:unbind(change)+change-prompt(filter> )+enable-search+clear-query' \
        --bind 'ctrl-r:rebind(change)+change-prompt(rfnvim> )+disable-search+clear-query' \
        --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
        --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~4,+{2}+4/3,<80(up)' \
        --query "$q"
end
