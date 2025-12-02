# zoxide (smarter cd)
if type -q zoxide
    zoxide init fish | source
end

# fzf
if type -q fzf
    fzf --fish | source
end

# fzf設定
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
