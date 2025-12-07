# ===========================================
# コマンド置換 (モダンCLIツール)
# ===========================================
# 注: 単純な省略形は 45-abbreviations.fish で定義
#     ここではコマンド自体を置き換えるaliasのみ定義

# eza (ls の代替)
if type -q eza
    alias ls 'eza --icons --group-directories-first'
    alias ll 'eza -la --icons --group-directories-first --git'
    alias lt 'eza --tree --icons -L 2'
    alias la 'eza -a --icons --group-directories-first'
end

# bat (cat の代替)
if type -q bat
    # batはディレクトリを処理できないため、関数で回避
    function cat --wraps=bat
        for arg in $argv
            if test -d "$arg"
                command cat $argv
                return
            end
        end
        bat $argv
    end
end

# ripgrep (grep の代替)
if type -q rg
    alias grep rg
end

# fd (find の代替)
if type -q fd
    alias find fd
end

# delta (diff の代替)
if type -q delta
    alias diff delta
end

# zoxide (cd の代替)
if type -q zoxide
    alias cd z
    alias cdi zi
end

# ===========================================
# macOS 固有コマンド
# ===========================================
alias finder 'open -a Finder'
alias chrome 'open -a "Google Chrome"'
alias code 'open -a "Visual Studio Code"'
alias ip 'ipconfig getifaddr en0'
alias flushdns 'sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias cleanup 'command find . -type f -name "*.DS_Store" -ls -delete'

# ===========================================
# 複雑なコマンド (abbreviation に不向き)
# ===========================================
# ツリー表示（除外パターン付き）
alias tree 'command tree -a -I ".git|node_modules|.next|__pycache__|.venv|.history"'

# プロセス検索
alias psgrep 'ps aux | command grep'
