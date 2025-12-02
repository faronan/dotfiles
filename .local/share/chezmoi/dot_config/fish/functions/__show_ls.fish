# ===========================================
# Common ls display function
# ===========================================

function __show_ls
    if type -q eza
        eza --icons --group-directories-first
    else
        ls
    end
end
