# ===========================================
# モダンCLIツール
# ===========================================
if type -q eza
    alias ls 'eza --icons --group-directories-first'
    alias ll 'eza -la --icons --group-directories-first --git'
    alias lt 'eza --tree --icons -L 2'
    alias la 'eza -a --icons --group-directories-first'
end

if type -q bat
    alias cat 'bat'
end

if type -q rg
    alias grep 'rg'
end

if type -q fd
    alias find 'fd'
end

if type -q delta
    alias diff 'delta'
end

# zoxide
if type -q zoxide
    alias cd 'z'
    alias cdi 'zi'
end

# ===========================================
# Git
# ===========================================
alias g 'git'
alias ga 'git add'
alias gc 'git commit'
alias gcm 'git commit -m'
alias gca 'git commit --amend'
alias gcac 'git commit --amend -C HEAD'
alias gcacn 'git commit --amend -C HEAD --date=now'
alias gp 'git push'
alias gpo 'git push origin'
alias gl 'git pull'
alias gs 'git status'
alias gd 'git diff'
alias gdh 'git diff HEAD'
alias gco 'git checkout'
alias gb 'git branch'
alias glog 'git log --oneline --graph --decorate'
alias gg 'git graph'
alias grs 'git reset'
alias grss 'git reset --soft'
alias grssh 'git reset --soft HEAD'
alias grsh 'git reset --hard'
alias gr 'git rebase'
alias gri 'git rebase -i'
alias gf 'git fetch'
alias gfo 'git fetch origin'
alias gsw 'git switch'
alias gswc 'git switch -c'

# ===========================================
# Node.js
# ===========================================
alias pn 'pnpm'
alias ni 'npm install'
alias nr 'npm run'

# ===========================================
# Docker
# ===========================================
alias dps 'docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dc 'docker compose'
alias dcu 'docker compose up'
alias dcud 'docker compose up -d'
alias dcd 'docker compose down'
alias dcb 'docker compose build'
alias dcrun 'docker compose run --rm'
alias dcl 'docker compose logs -f'

# ===========================================
# macOS固有
# ===========================================
alias finder 'open -a Finder'
alias chrome 'open -a "Google Chrome"'
alias code 'open -a "Visual Studio Code"'
alias ip 'ipconfig getifaddr en0'
alias flushdns 'sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias cleanup 'command find . -type f -name "*.DS_Store" -ls -delete'

# ===========================================
# その他
# ===========================================
alias reload 'exec fish'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'

# ディスク使用量（ソート済み）
alias duh 'du -shc * | sort -h'

# ツリー表示（除外パターン付き）
alias tree 'command tree -a -I ".git|node_modules|.next|__pycache__|.venv|.history"'

# プロセス検索
alias psgrep 'ps aux | command grep'
