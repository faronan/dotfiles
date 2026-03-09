# ===========================================
# fzf file search (Ctrl+F)
# ===========================================

function __fzf_file_search
    # Use bat for preview if available, fallback to head
    set -l preview_cmd
    if type -q bat
        set preview_cmd "bat --color=always --style=numbers --line-range=:500 {}"
    else
        set preview_cmd "head -100 {}"
    end

    # Use fd if available, fallback to find
    set -l selected
    if type -q fd
        set selected (fd --type f --hidden --exclude .git | fzf \
            --preview "$preview_cmd" \
            --preview-window 'right,50%,border-left' \
            --ghost 'Search files...')
    else
        set selected (command find . -type f -not -path '*/.git/*' | fzf \
            --preview "$preview_cmd" \
            --ghost 'Search files...')
    end

    if test -n "$selected"
        commandline -i $selected
    end
    commandline -f repaint
end
