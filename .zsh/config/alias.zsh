# general
alias reload='source $ZDOTDIR/.zshrc'
alias fgrep='find ./ | grep'
alias du='du -shc * | sort -h'
# alias ls='ls -aCFG'
alias tree='tree -a -I ".git|.history|node_modules|__pycache__"'
alias psgrep='ps aux | grep'

# custom command
alias 'gco'=git_checkout

# substitute
alias ls='lsd'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias cat='bat'
alias fd='fd -H'

# git
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcac='git commit --amend -C HEAD'
alias gcacn='git commit --amend -C HEAD --date=now'
alias glo='git log --oneline'
alias gdh='git diff HEAD'
alias gpo='git push origin'
alias grs='git reset'
alias grss='git reset --soft'
alias grssh='git reset --soft HEAD'
alias grsh='git reset --hard'
alias gr='git rebase'
alias gri='git rebase -i'
alias gf='git fetch'
alias gfo='git fetch origin'
alias gg='git graph'
alias gs='git switch'
alias gsc='git switch -c'

alias gcode="cd ~/dotfiles && git checkout -b vscode_update || git checkout vscode_update && cp -f ~/Library/'Application Support'/Code/User/settings.json ./.vscode/settings.json && git add ./.vscode/settings.json && git commit && git push origin vscode_update && git checkout master && cd -"

# docker
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}"'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcb='docker-compose build'
alias dcrun='docker-compose run --rm'
