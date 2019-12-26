## enterをおした時にls & git status
function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    echo -e "\e[0;33m--- ls ---\e[0m"
    ls
    # ↓おすすめ
    # ls_abbrev
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
        echo "
        "
    fi
    zle reset-prompt
    return 0
}

zle -N do_enter
bindkey '^m' do_enter

function ls_abbrev() {
  local ls_result
  ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command \
    ls -CF -Gh | sed $'/^\e\[[0-9;]*m$/d')

  if [ $(echo "$ls_result" | wc -l | tr -d ' ') -gt 50 ]; then
    echo "$ls_result" | head -n 10
    echo '......'
    echo "$ls_result" | tail -n 10
    echo "${fg_bold[yellow]}$(command ls -1 -A | wc -l | tr -d ' ')" \
      "files exist${reset_color}"
  else
    echo "$ls_result"
  fi
}

path_history=($(pwd))
path_history_index=1
path_history_size=1

function push_path_history() {
  local curr_path
  curr_path=$1
  if [ $curr_path != $path_history[$path_history_index] ]; then
    local path_history_cap
    path_history_cap=$#path_history
    if [ $path_history_index -eq $path_history_cap ]; then
      local next_cap
      next_cap=$(($path_history_cap * 2))
      path_history[$next_cap]=
    fi
    path_history_index=$(($path_history_index+1))
    path_history[$path_history_index]=$curr_path
    path_history_size=$path_history_index
  fi
}

function dir_back() {
  if [ $path_history_index -ne 1 ]; then
    path_history_index=$(($path_history_index-1))
    local prev_path
    prev_path=$path_history[$path_history_index]
    echo "cd $prev_path"
    cd $prev_path
    zle accept-line
  fi
}

function dir_forward() {
  if [ $path_history_index -ne $path_history_size ]; then
    path_history_index=$(($path_history_index+1))
    local next_path
    next_path=$path_history[$path_history_index]
    echo "cd $next_path"
    cd $next_path
    zle accept-line
  fi
}

function reset_path_history() {
  path_history=($(pwd))
  path_history_index=1
  path_history_size=1
}

function chpwd() {
  push_path_history $(pwd)
  ls_abbrev
}