#!/usr/bin/env bash

get_package_management_system() {
    . /etc/os-release
    DISTRIBUTION=$ID

    if [ "$DISTRIBUTION" = "elementary" ]; then
        PKG_INSTALL="apt install"
        PKG_DB_UPDATE="apt update"
    else
        PKG_INSTALL="pacman -S"
        PKG_DB_UPDATE="pacman -Syy"
    fi
}

install_requirements() {
    sudo $PKG_DB_UPDATE
    sudo $PKG_INSTALL cscope cmake tmux zsh ripgrep

    if [ "$DISTRIBUTION" = "elementary" ]; then
        sudo $PKG_INSTALL python-dev python3-dev build-essential silversearcher-ag
    else
        sudo $PKG_INSTALL python2 python base-devel the_silver_searcher
    fi
}


install_and_set_vim() {
    ln -fs `pwd`/vim/vimrc ~/.vimrc
    ln -fs `pwd`/vim/ycm_extra_conf.py ~/.ycm_extra_conf.py

    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    vim +PluginInstall +qall
    ~/.vim/bundle/YouCompleteMe/install.py --clang-completer
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
    rm -f ~/.tmux.conf
    cp tmux/tmux.conf ~/.tmux.conf
}


main() {
    echo get package management system ...
    get_package_management_system

    echo installing requirements ...
    install_requirements

    echo installing and setting vim ...
    install_and_set_vim

    echo installing and setting oh-my-zsh ...
    install_and_set_ohmyzsh

    echo installing and setting tmux ...
    install_and_set_tmux
}

main
