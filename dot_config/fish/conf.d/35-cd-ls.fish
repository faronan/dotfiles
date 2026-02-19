# ===========================================
# Auto ls on directory change
# ===========================================

function __auto_ls_on_cd --on-variable PWD
    # Only run in interactive shells, not in command substitution
    if status is-interactive; and not status is-command-substitution
        __show_ls
    end
end
