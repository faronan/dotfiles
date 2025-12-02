function fvim --description 'Open file in vim with fzf'
    set -l file (fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')
    if test -n "$file"
        vim $file
    end
end
