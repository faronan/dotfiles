function proj --description 'Jump to project directory with fzf'
    set -l dir (fd --type d --max-depth 2 . ~/Projects 2>/dev/null | fzf)
    if test -n "$dir"
        cd "$dir"
    end
end
