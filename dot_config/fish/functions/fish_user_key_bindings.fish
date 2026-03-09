# ===========================================
# Fish Key Bindings
# ===========================================

function fish_user_key_bindings
    # fzf integration
    if type -q fzf
        # Ctrl+R: Atuin に移行（60-atuin.fish で設定）

        # Ctrl+G: ghq repository search
        if type -q ghq
            bind ctrl-g '__fzf_ghq_search'
            bind -M insert ctrl-g '__fzf_ghq_search'
        end

        # Ctrl+F: file search
        bind ctrl-f '__fzf_file_search'
        bind -M insert ctrl-f '__fzf_file_search'
    end
end
