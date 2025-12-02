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
alias gp 'git push'
alias gl 'git pull'
alias gs 'git status'
alias gd 'git diff'
alias gco 'git checkout'
alias gb 'git branch'
alias glog 'git log --oneline --graph --decorate'

# ===========================================
# Node.js
# ===========================================
alias pn 'pnpm'
alias ni 'npm install'
alias nr 'npm run'

# ===========================================
# macOS固有
# ===========================================
alias finder 'open -a Finder'
alias chrome 'open -a "Google Chrome"'
alias code 'open -a "Visual Studio Code"'
alias ip 'ipconfig getifaddr en0'
alias flushdns 'sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias cleanup 'find . -type f -name "*.DS_Store" -ls -delete'

# ===========================================
# その他
# ===========================================
alias reload 'source ~/.config/fish/config.fish'
alias path 'echo $PATH | tr " " "\n"'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
