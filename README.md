# Yao-Yu's Dotfiles
This is my dotfiles which personalize my debian based distributions systems.

## What's Inside
Configuration files includes my vim settings, zsh settings with oh-my-zsh, and 
tmux settings with tmux-resurrect.

## Prerequisite
* cscope 
* cmake
* python-dev
* python3-dev
* tmux
* zsh
* build-essential

## Installations
Clone this repository if you want to apply my dotfiles.

Install by running install.sh with root permission since the function 
install_requirements() in install.sh may install the prerequisite packages.
```
sudo ./install.sh
```

Or you can install the prequisite packages listed above, remove 
install_requirements() functions in install.sh, and execute install.sh directly.
```
./install.sh
```
