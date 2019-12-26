cp .zshenv ~/

if [ ! -e ~/.zplugin ]; then
	mkdir ~/.zplugin
  git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
  source ~/.zplugin/bin/zplugin.zsh
fi