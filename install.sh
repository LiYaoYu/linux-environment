#!/usr/bin/env bash

install_requirements() {
  sudo apt-get update
  sudo apt install cscope cmake python-dev python3-dev tmux zsh build-essential
}


copy_required_files() {
  ln -fs `pwd`/vim/vimrc ~/.vimrc
  ln -fs `pwd`/vim/ycm_extra_conf.py ~/.ycm_extra_conf.py
  ln -fs `pwd`/tmux/tmux.conf ~/.tmux.conf
}


replace_rm() {
  mv /bin/rm bin/rm.bak
  ln -fs `pwd`/rm/rm.rep /bin/rm
}


install_vundle() {
  git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
}


install_vim_plugins() {
  vim +PluginInstall +qall
}


compile_ycm_essential() {
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


main () {
  echo installing requirements ...
  install_requirements

  echo copying required files to home ...
  copy_required_files

  # echo replace rm command ...
  #replace_rm

  echo installing vundle ...
  install_vundle

  echo installing vim plugins ...
  install_vim_plugins

  echo compiling YCM with semantic support for C-family languages ...
  compile_ycm_essential

  echo installing and setting oh-my-zsh ...
  install_and_set_ohmyzsh

  echo running oh-my-zsh with settings
  env zsh
}

main
