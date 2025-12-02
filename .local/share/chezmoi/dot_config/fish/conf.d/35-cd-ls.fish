# ===========================================
# Auto ls on directory change
# ===========================================

function __auto_ls_on_cd --on-variable PWD
    # Only run in interactive shells
    if status is-interactive
        __show_ls
    end
end
