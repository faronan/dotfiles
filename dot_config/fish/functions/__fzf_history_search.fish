# ===========================================
# fzf history search (Ctrl+R)
# ===========================================

function __fzf_history_search
    set -l selected (history | fzf --height 40% --reverse --query=(commandline))
    if test -n "$selected"
        commandline -rb $selected
    end
    commandline -f repaint
end
