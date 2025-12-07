# ===========================================
# fzf file search (Ctrl+F)
# ===========================================

function __fzf_file_search
    # Use fd if available, fallback to find
    set -l find_cmd
    if type -q fd
        set find_cmd "fd --type f --hidden --exclude .git"
    else
        set find_cmd "command find . -type f -not -path '*/.git/*'"
    end

    # Use bat for preview if available, fallback to head
    set -l preview_cmd
    if type -q bat
        set preview_cmd "bat --color=always --style=numbers --line-range=:500 {}"
    else
        set preview_cmd "head -100 {}"
    end

    set -l selected (eval $find_cmd | fzf --height 40% --reverse --preview "$preview_cmd")
    if test -n "$selected"
        # Insert the selected file path at cursor
        commandline -i $selected
    end
    commandline -f repaint
end
