#!/bin/bash

set -e

# env vars edited
echo "VISUAL=vim" >> ~/.bashrc
# source bashrc
source ~/.bashrc

# current user info
echo -e "Current user info:\n$(id)"

# check sudo permissions
echo -e "Current user sudo permissions:\n$(sudo -l)"


# install basic tools
declare -a tools_to_install=(man-db git curl xclip fzf)
echo -e "\nUpdating apt package lists."
sudo apt-get update
echo -e "Installing tools"
for tool in "${tools_to_install[@]}"
do
    echo -e "\nInstalling $tool"
    sudo apt-get -y -qq install $tool
done

# setting up shell integration for fzf
echo 'eval "$(fzf --bash)"' >> ~/.bashrc


# check if dir for github key already exists, if not, create it
GITHUB_KEYS_PATH="~/.ssh/github_keys"
if [ ! -d $GITHUB_KEYS_PATH ] || [ -h $GITHUB_KEYS_PATH  ]; then
    echo "$GITHUB_KEYS_PATH doesn't exist, creating..."
    mkdir $GITHUB_KEYS_PATH
    echo "Done"
fi

# ssh-keygen ecdsa keys (rsa and dsa are old algos - can use rsa but try to avoid dsa as much as possible)
echo -e "Creating Github ssh keys at $GITHUB_KEYS_PATH. Please add the public key to Github."
ssh-keygen -t ecdsa -b 521 -f ~/.ssh/github_keys/github

# copy github public ssh key to clipboard
xclip -sel clip ~/.ssh/github_keys/github.pub

# add entry to ssh config
echo "Adding Github host config to ssh config."
echo -e "Host github.com\n\tHostName github.com\n\tIdentityFile ~/.ssh/${GITHUB_KEYS_PATH}/github" >> ~/.ssh/config


# set git configs
echo "Setting git configs (globally)"
git config --global user.email $(IFS= read -p 'Enter email: ' && printf '%s' $REPLY)
git config --global user.name $(IFS= read -p 'Enter username: ' && printf '%s' $REPLY)
git config --global core.editor vim && echo "Set core git editor to vim"
