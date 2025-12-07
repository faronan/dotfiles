# ===========================================
# fzf ghq repository search (Ctrl+G)
# ===========================================

function __fzf_ghq_search
    # Use eza for preview if available, fallback to ls
    set -l preview_cmd
    if type -q eza
        set preview_cmd "eza --icons --group-directories-first {}"
    else
        set preview_cmd "ls -la {}"
    end

    set -l selected (ghq list --full-path | fzf --height 40% --reverse --preview "$preview_cmd")
    if test -n "$selected"
        cd $selected
        commandline -f repaint
    end
end
