#!/bin/bash

source helper_funcs.sh

GITHUB_KEYS_PATH="${HOME}"/.ssh/github_keys

# set git configs
function set_git_configs {

    echo "[+] Git Config Setup (globally)"

    echo "[-] Github linked email must be entered if one wants their commits using it to be counted in the Contribution table as 'green'."
    IFS= read -rp 'Enter username: ' git_name
    IFS= read -rp 'Enter email: ' git_email

    git config --global user.name "${git_name}"
    git config --global user.email "${git_email}"
    git config --global core.editor vim && echo "Set core git editor to vim"

}


# to setup git
function git_setup {

    print_div
    print_div

    if is_tool_installed "git"; then
        echo "[+] Git present, proceeding"
    else
        echo "[+] Installing git..."
        apt install -qq -y git
    fi

    set_git_configs

    # check if dir for github key already exists, if not, create it
    echo "[+] Creating directory for github keys if not present..."
    if [[ ! -d "$GITHUB_KEYS_PATH" ]]; then
        echo "[-] $GITHUB_KEYS_PATH doesn't exist, creating..."
        mkdir "${GITHUB_KEYS_PATH}"
        echo "[-] Done"
    else
        echo "[-] Directory exists, proceeding..."
    fi

    # ssh-keygen ecdsa keys (rsa and dsa are old algos - can use rsa but try to avoid dsa as much as possible)
    echo "[+] Creating github key-pair if not present..."
    if [[ ! -f "${GITHUB_KEYS_PATH}"/github ]]; then
        echo -e "[-] Creating Github ssh keys at \"${GITHUB_KEYS_PATH}\". Please add the public key to Github."
        ssh-keygen -t ecdsa -b 521 -f "${GITHUB_KEYS_PATH}"/github
    else
        echo "[-] Keys exist, proceeding..."
    fi

    # displaying cmd to copy github public ssh key to clipboard
    echo "[+] Use below command to copy key to clipboard, and then can manually add to Github"
    echo "xclip -sel clip \"${GITHUB_KEYS_PATH}\"/github.pub"

    # add entry to ssh config
    echo "[+] Adding Github host config to ssh config."
    echo -e "Host github\n\tHostName github.com\n\tIdentityFile \"${GITHUB_KEYS_PATH}\"/github" >> ~/.ssh/config

}


git_setup
