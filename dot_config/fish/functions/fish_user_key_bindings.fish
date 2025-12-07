# ===========================================
# Fish Key Bindings
# ===========================================

function fish_user_key_bindings
    # fzf integration
    if type -q fzf
        # Ctrl+R: history search
        bind \cr '__fzf_history_search'
        bind -M insert \cr '__fzf_history_search'

        # Ctrl+G: ghq repository search
        if type -q ghq
            bind \cg '__fzf_ghq_search'
            bind -M insert \cg '__fzf_ghq_search'
        end

        # Ctrl+F: file search
        bind \cf '__fzf_file_search'
        bind -M insert \cf '__fzf_file_search'
    end
end
