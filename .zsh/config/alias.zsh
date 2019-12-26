# general
alias reload='source ~/.zshrc'
alias fgrep='find ./ | grep'
alias du='du -shc * | sort -h'

# git
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gdh='git diff HEAD'
alias gpo='git push origin'
alias grs='git reset'
alias grss='git reset --soft'
alias grssh='git reset --soft HEAD'
alias grsh='git reset --hard'
alias gr='git rebase'
alias gri='git rebase -i'
alias gf='git fetch'
alias gf='git fetch origin'

# docker
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}"'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcrr='docker-compose run --rm'