function eza --wraps=eza --description 'always have icons for eza'
    command eza --icons --group-directories-first -F --color=always $argv
end
