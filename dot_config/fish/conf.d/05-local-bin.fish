# User local binaries
# ~/bin - chezmoi公式インストーラーのデフォルト配置先
# ~/.local/bin - ユーザーローカルの実行ファイル置き場（XDG仕様準拠）
#                Claude Code, pipx, cargo install --root などが使用
fish_add_path -g $HOME/bin
fish_add_path -g $HOME/.local/bin
