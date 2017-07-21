# Linux Environment Settings
##### Includes:
* vim settings (vimrc)
* screen settings (screen)

*** 
Initialize settings by (if any of them are needed)
```
cp vim/vimrc ~/.vimrc
cp screen/screenrc ~/.screenrc
```

## Vim Settings
### Vundle Installation
```
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
```
### Plugin Installation
Enter vim and input:
```
:PluginInstall
```
### Cscope Setup
##### Requirement:
* cscope
### YouCompleteMe Setup
##### Requirement:
* cmake
* python-dev 
* python3-dev

Compiling YCM with semantic support for C-family languages:
```
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer
```
Set the YCM configuration for specific project:
```
cp vim/ycm_extra_conf.py ~/.ycm_extra_conf.py
```

with option compilation flags:
```
flags = [
'-Wall',
'-Wextra',
'-DUSE_CLANG_COMPLETER',
'-I',
'include',
'-isystem',
'/usr/include/'
]
```
