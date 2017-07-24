#!/usr/bin/env bash

echo setting environment ...

echo installing requirements ...
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install cscope cmake python-dev python3-dev zsh

echo copying required files to home ...
cp vim/vimrc ~/.vimrc
cp vim/ycm_extra_conf.py ~/.ycm_extra_conf.py
cp screen/screenrc ~/.screenrc

echo installing vundle ...
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

echo installing plugins ...
vim +PluginInstall +qall

echo compiling YCM with semantic support for C-family languages ...
~/.vim/bundle/YouCompleteMe/install.sh --clang-completer

echo installing oh-my-zsh ...
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo setting oh-my-zsh ...
cp zsh/zshrc ~/.zshrc
cp zsh/mytheme.zsh-theme ~/.oh-my-zsh/themes/
