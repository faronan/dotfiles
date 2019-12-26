# zplugin {{{
source ~/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
# }}}

# autoload {{{
autoload -Uz colors && colors
autoload -Uz compinit && compinit -u
# cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
# }}}

# SUB FILES {{{
# plugin
source $ZDOTDIR/config/plugin.zsh
# key
source $ZDOTDIR/config/key.zsh

# alias
source $ZDOTDIR/config/alias.zsh

# completion
source $ZDOTDIR/config/completion.zsh

# function
source $ZDOTDIR/config/function.zsh

# peco
source $ZDOTDIR/config/peco.zsh

# local setting
if [[ -e ~/.zshrc_local ]]; then
    source ~/.zshrc_local
fi
# }}}