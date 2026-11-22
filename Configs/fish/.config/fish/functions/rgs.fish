function rgs --description 'Live ripgrep search; print the directory of each picked match'
    set -l q (string join ' ' -- $argv)

    # --hidden includes dotfiles; the glob excludes .git; .gitignore is still honoured
    set -l rg_cmd "rg --column --line-number --no-heading --color=always --smart-case --hidden --glob '!**/.git/*'"

    # Commands below are POSIX sh (see --with-shell), not fish.
    # fzf kills the previous reload when a new one starts, so no debounce sleep is needed.
    set -l reload "reload:[ -n {q} ] && $rg_cmd -- {q} || true"
    set -l opener 'if [ "$FZF_SELECT_COUNT" -eq 0 ]; then nvim {1} +{2}; else nvim +cw -q {+f}; fi'

    set -l header 'enter: dir · ctrl-o: nvim · ctrl-f: filter · ctrl-r: rg · alt-a/d: (de)select all · ctrl-/: preview'

    set -l picked (
        fzf --with-shell 'sh -c' \
            --disabled --ansi --multi \
            --prompt 'rgs> ' \
            --header $header \
            --bind "start:$reload" \
            --bind "change:$reload" \
            --bind "ctrl-o:execute:$opener" \
            --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
            --bind 'ctrl-f:unbind(change)+change-prompt(fzf> )+enable-search+clear-query' \
            --bind 'ctrl-r:rebind(change)+change-prompt(rgs> )+disable-search+clear-query' \
            --delimiter : \
            --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
            --preview-window '~4,+{2}+4/3,<80(up)' \
            --query "$q"
    )
    or return

    # Each line is file:line:col:text; keep the file's directory, one per unique dir
    for line in $picked
        path dirname -- (string split --max 1 -- : $line)[1]
    end | sort -u
end
