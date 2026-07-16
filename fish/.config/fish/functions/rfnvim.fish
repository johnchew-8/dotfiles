# Integrate rg-fzf-nvim - grep for "string" across fzf files open in nvim

function rfnvim
    set -l q (string join ' ' -- $argv)
    set -l reload 'reload:rg --column --color=always --smart-case {q}; or true'
    set -l opener 'if test "$FZF_SELECT_COUNT" -eq 0; nvim {1} +{2}; else; nvim +cw -q {+f}; end'

    fzf --disabled --ansi --multi \
        --bind "start:$reload" \
        --bind "change:$reload" \
        --bind "enter:become:$opener" \
        --bind "ctrl-o:execute:$opener" \
        --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
        --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~4,+{2}+4/3,<80(up)' \
        --query "$q"
  end
