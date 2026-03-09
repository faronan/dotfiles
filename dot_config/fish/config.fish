# ===========================================
# Fish Shell Configuration
# ===========================================
# conf.d/ 内のファイルは自動で読み込まれる
# このファイルは最後に読み込まれる

# インタラクティブシェルのみ
if not status is-interactive
    return
end

# 挨拶メッセージを無効化
set -g fish_greeting

# Starship prompt
starship init fish | source
enable_transience

# Zellij aliases
abbr -a zj "zellij"
abbr -a zd "zellij --layout dev"
abbr -a zw "zellij -s work --layout dev"
abbr -a za "zellij attach"
