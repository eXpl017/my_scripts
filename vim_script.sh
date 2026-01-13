#!/bin/bash

set -e

# check if git available
if ( ! command -v git >/dev/null 2>&1); then
    echo "Git unavailable, install and set-up git. Exiting..."
    exit 22
else
    echo "[+] Git available, proceeding..."
fi

echo

# check if vim available
if ( ! command -v vim >/dev/null 2>&1 ); then
    echo "[+] Intalling vim"
    sudo apt-get install vim-gtk3
else
    echo "Vim exists!"
fi

echo

# create directory tree for vim config
declare -a req_dirs=(autoload plugged colors backup)
for dir_ in ${req_dirs[@]}; do
    if [[ ! -d ~/.vim/${dir_} ]]; then
        mkdir -p ~/.vim/${dir_}
    fi
done
echo "Created required dirs at ~/.vim"

echo

# backup current vim config
if [[ -d ~/.vim ]]; then
    echo "[!] Note: Backing up ~/.vim to ~/.vim.bak, overwrites any existing backups."
    mv -f ~/.vim ~/.vim.bak
fi

echo

# fetch vimConfig from github
echo "Cloning vimConfig in user home directory"
git clone https://github.com/eXpl017/vimConfig.git ~/vimConfig

# copy config files to .vim
if [[ ! -d ~/.vim ]]; then
    mkdir ~/.vim
fi
cp ~/vimConfig/{vimrc,autoclose.vim} ~/.vim
echo "Copied config files to ~/.vim"

echo

# install plugins and close all vim sessions
vim +PlugInstall +qa
