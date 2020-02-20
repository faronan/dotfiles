create_symlink() {
  if [ ! -e "$1" ]; then
    echo "no link: $1"
  elif [ -e "$2" ]; then
    echo "already exists: $2"
  else
    ln -s "$1" "$2"
    echo "sucess!: $2 -> $1"
  fi
}

# git...etc
DOT_FILES=(
  .zshenv
  .gitconfig
  )

cd "$HOME"

for file in ${DOT_FILES[@]}; do
  create_symlink dotfiles/$file $HOME/$file
done

#zplugiin
if [ ! -e ~/.zplugin ]; then
	mkdir ~/.zplugin
  git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
  source ~/.zplugin/bin/zplugin.zsh
fi

#git
create_symlink dotfiles/.gitconfig $HOME/.gitconfig
create_symlink dotfiles/.git_config/.gitignore_global $HOME/.gitignore_global
create_symlink dotfiles/.git_config/.gitconfig.local $HOME/.gitconfig.local

#.vscode
cp -f dotfiles/.vscode/settings.json ~/Library/'Application Support'/Code/User/settings.json