#!/usr/bin/env bash

install_requirements() {
  sudo apt-get update
  sudo apt install cscope cmake python-dev python3-dev tmux zsh build-essential
}


replace_rm() {
  mv /bin/rm bin/rm.bak
  ln -fs `pwd`/rm/rm.rep /bin/rm
}


install_and_set_vim() {
  ln -fs `pwd`/vim/vimrc ~/.vimrc
  ln -fs `pwd`/vim/ycm_extra_conf.py ~/.ycm_extra_conf.py

  git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  vim +PluginInstall +qall
  ~/.vim/bundle/YouCompleteMe/install.sh --clang-completer
}


install_and_set_ohmyzsh() {
  # "https://git.io/vhqYi" is the shorten URL of oh-my-zsh installation script
  # which allows batch mode and is updated in pull requests #5893, link is as 
  # below:
  # "https://github.com/robbyrussell/oh-my-zsh/pull/5893"
  sh -c "$(curl -fsSL https://git.io/vhqYi)" -s --batch || {
    echo "Could not install Oh My Zsh" >/dev/stderr
    exit 1
  }

  ln -fs `pwd`/zsh/zshrc ~/.zshrc
  ln -fs `pwd`/zsh/mytheme.zsh-theme ~/.oh-my-zsh/themes/mytheme.zsh-theme
}


install_and_set_tmux() {
  rm -rf `pwd`/tmux/tres
  git clone https://github.com/tmux-plugins/tmux-resurrect `pwd`/tmux/tres

  cp tmux/tmux.conf ~/.tmux.conf
  echo "run-shell `pwd`/tmux/tres/resurrect.tmux" >> ~/.tmux.conf
}

main() {
  echo installing requirements ...
  install_requirements

  # echo replace rm command ...
  #replace_rm

  echo installing and setting vim ...
  install_and_set_vim

  echo installing and setting oh-my-zsh ...
  install_and_set_ohmyzsh

  echo installing and setting tmux ...
  install_and_set_tmux
}

main
