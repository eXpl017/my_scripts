#!/bin/bash

set -e

# check if git available
if ( ! command -v git ); then
	echo "Git unavailable, install and set-up git. Exiting..."
	exit 22
else
	echo "Git available, proceeding..."
fi


# check if vim available
if ( ! command -v vim ); then
	echo "Intalling vim"
	sudo apt-get install vim
else
	echo "Vim exists!"
fi

# create directory tree for vim config
declare -a req_dirs=(autoload plugged colors backup)
for dir_ in ${req_dirs[@]}; do
	if [[ ! -d ~/.vim/${dir_} ]]; then
		mkdir -p ~/.vim/${dir_}
    fi
done
echo "Created required dirs at ~/.vim"


# fetch vimConfig from github
echo "Cloning vimConfig in user home directory"
git clone git@github.com:eXpl017/vimConfig.git ~/vimConfig

# copy config files to .vim
cp vimrc autoclose.vim ~/.vim
echo "Copied config files to ~/.vim"
echo 'To install vimplug and plugins specified in config file, you may use `:source ~/.vim/vimrc` in any existing session, or start a new session'
