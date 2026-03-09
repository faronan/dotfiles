# zoxide (smarter cd)
if type -q zoxide
    zoxide init fish | source
end

# fzf
if type -q fzf
    fzf --fish | source
end

# fzf settings
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'

# fzf UI options (requires fzf 0.58+)
set -gx FZF_DEFAULT_OPTS "\
  --style=full \
  --height=80% \
  --layout=reverse \
  --wrap=word \
  --bind 'ctrl-/:toggle-wrap-word'"

# Ctrl+T: file search with bat preview
if type -q bat
    set -gx FZF_CTRL_T_OPTS "\
      --preview 'bat --color=always --style=header,grid --line-range :300 {}' \
      --preview-window 'right,50%,wrap-word' \
      --bind 'ctrl-/:toggle-preview'"
end

# Alt+C: directory search with preview
if type -q eza
    set -gx FZF_ALT_C_OPTS "--preview 'eza --icons --group-directories-first {}'"
else
    set -gx FZF_ALT_C_OPTS "--preview 'ls -la {}'"
end

# ripgrep設定ファイルパス
set -gx RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/config"
