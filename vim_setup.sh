#!/bin/bash

source helper_funcs.sh

VIM_CONFIG_PATH="${HOME}"/.vim

function vim_setup {

    print_div
    print_div

    echo "[+] Setting up Vim"

    # backup current vim config
    if [[ -d "${VIM_CONFIG_PATH}" ]]; then
        echo "[+] Backing up current vim config"
        mv "${VIM_CONFIG_PATH}" "${HOME}"/.vim.bak."$(date +%F)"
    fi

    # creating fresh .vim directory tree with subdirs for config
    mkdir "${VIM_CONFIG_PATH}"
    declare -a req_dirs=(autoload plugged colors backup)
    for dir_ in "${req_dirs[@]}"; do
        mkdir "${VIM_CONFIG_PATH}/${dir_}"
    done
    echo "[+] Created required directories under \"${VIM_CONFIG_PATH}\""

    # fetch my vim config files from github
    echo "[+] Cloning vimConfig in user home directory"
    if [[ -d "${USER_HOME}/vimConfig" ]]; then
        echo "[-] vimConfig dir is already present, please pull latest changes from github."
    else
        git clone https://github.com/eXpl017/vimConfig.git "${HOME}"/vimConfig
    fi

    # copy config files to .vim
    echo "[+] Copying config to .vim/"
    cp "${HOME}"/vimConfig/{autoclose.vim,vimrc} "${VIM_CONFIG_PATH}"/

    # install plugins and close all vim sessions
    echo "[+] Installing plugins"
    vim +PlugInstall +qa
}


vim_setup
