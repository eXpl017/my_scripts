#!/bin/bash

set -e
# set -x

##### VAR DECLARATION #####

# height and width of terminal window are stored in $LINES and $COLUMNS
USER_HOME=$( getent passwd "${USER}" | cut -d: -f6 )
USER_SHELL=$( getent passwd "${USER}" | cut -d: -f7 )
BASHRC_PATH=${USER_HOME}/.bashrc
VIM_CONFIG_PATH=${USER_HOME}/.vim
GITHUB_KEYS_PATH=${USER_HOME}/.ssh/github_keys


##### FUNCTIONS #####

# to print a divider
function print_div() {
    printf '#%.0s' $(seq 1 $COLUMNS)
}

# to check if command is installed on the system
function is_tool_installed() {
    command -v "$1" >/dev/null 2>&1
}

# set git configs
function set_git_configs() {

    echo "[+] Git Config Setup (globally)"

    echo "[-] Github linked email must be entered if one wants their commits using it to be counted in the Contribution table as 'green'."
    IFS= read -rp 'Enter username: ' git_name
    IFS= read -rp 'Enter email: ' git_email

    git config --global user.name ${git_name}
    git config --global user.email ${git_email}
    git config --global core.editor vim && echo "Set core git editor to vim"

}


# to setup git
function git_setup() {

    if is_tool_installed "git"; then
        echo "[+] Git present, proceeding"
    else
        echo "[+] Installing git..."
        apt install -qq -y git-all
    fi

    set_git_configs

    # check if dir for github key already exists, if not, create it
    echo "[+] Creating directory for github keys if not present..."
    if [[ ! -d "$GITHUB_KEYS_PATH" ]]; then
        echo "[-] $GITHUB_KEYS_PATH doesn't exist, creating..."
        mkdir $GITHUB_KEYS_PATH
        echo "[-] Done"
    fi

    # ssh-keygen ecdsa keys (rsa and dsa are old algos - can use rsa but try to avoid dsa as much as possible)
    echo "[+] Creating github key-pair if not present..."
    if [[ ! -f ${GITHUB_KEYS_PATH}/github ]]; then
        echo -e "[-] Creating Github ssh keys at $GITHUB_KEYS_PATH. Please add the public key to Github."
        ssh-keygen -t ecdsa -b 521 -f ${GITHUB_KEYS_PATH}/github
    else
        echo "[-] Keys exist, proceeding..."
    fi

    # displaying cmd to copy github public ssh key to clipboard
    echo "[+] Use below command to copy key to clipboard, and then can manually add to Github"
    echo "xclip -sel clip ${GITHUB_EYS_PATH}/github.pub"

    # add entry to ssh config
    echo "[+] Adding Github host config to ssh config."
    echo -e "Host github-personal\n\tHostName github.com\n\tIdentityFile ${GITHUB_KEYS_PATH}/github" >> ~/.ssh/config

}

function vim_setup() {

    echo "Setting up Vim"

    # backup current vim config, create if not present
    if [[ -d ${VIM_CONFIG_PATH} ]]; then
        echo "Backing up current vim config"
        mv ${VIM_CONFIG_PATH} ${USER_HOME}/.vim.bak.$(date +%F)
    fi

    # creating fresh .vim directory tree with subdirs for config
    mkdir ${VIM_CONFIG_PATH}
    declare -a req_dirs=(autoload plugged colors backup)
    for dir_ in ${req_dirs[@]}; do
        mkdir "${VIM_CONFIG_PATH}/${dir_}"
    done
    echo "Created required directories under ${VIM_CONFIG_PATH}"

    # fetch my vim config files from github
    echo " Cloning vimConfig in user home directory"
    if [[ -d "${USER_HOME}/vimConfig" ]]; then
        mv ${USER_HOME}/vimConfig ${USER_HOME}/vimConfig.old
    fi
    git clone https://github.com/eXpl017/vimConfig.git ${USER_HOME}/vimConfig

    # copy config files to .vim
    cp ${USER_HOME}/vimConfig/{autoclose.vim,vimrc} ${VIM_CONFIG_PATH}/

    # install plugins and close all vim sessions
    vim +PlugInstall +qa
}


##### SCRIPT BEGIN #####


# current user shell
# exit if not bash
# echo "User login shell: ${USER_SHELL}"
# if [[ ${USER_SHELL} -ne $( which bash ) ]]; then
#     echo "User not using bash...exiting"
#     exit 1
# fi
# echo

# current user info
echo -e "[+] Current user info:\n$(id)"
echo

# check sudo permissions
echo -e "[+] Current user sudo permissions:\n$(sudo -l)"
echo

# system info
echo "[+] Basic system version info:"
echo -e "[-] /proc/version\n\"$(</proc/version)\""
echo -e "[-] uname -a\n\"$(uname -a)\""
echo -e "[-] /etc/os-release\n\"$(</etc/os-release)\""
echo

# install basic tools
declare -a tools_to_install=(curl xclip fzf tmux vim bat)
echo -e "[+] Updating apt package lists."
sudo apt-get -qq update
print_div
echo "[+] Installing tools"
for tool in "${tools_to_install[@]}"
do
    if is_tool_installed "$tool"; then
        echo "[-] $tool is already available on the system!"
    else
        echo "\n[-] Installing $tool"
        sudo apt-get -y -qq install $tool
        echo "[-] Done"
    fi
    print_div
done

echo "[+] Done with installing tools."
echo

echo "[+] Performing re-check to see if tools installed"
for tool in "${tools_to_install[@]}"
do
    if is_tool_installed "$tool"; then
        continue
    else
        echo "[-] $tool not installed."
    fi
    print_div
done
echo "[+] Done"

print_div

git_setup
vim_setup

##### BASHRC CHANGES #####

echo "[+] Making required changes to bashrc..."

# setting up shell integration for fzf
echo 'eval "$(fzf --bash)"' >> ${BASHRC_PATH}

# replace cat with bat
echo 'alias cat="bat --pager=never --show-all"' >> ${BASHRC_PATH}

# setting vim as default editor
echo "VISUAL=vim" >> ${BASHRC_PATH}
echo "EDITOR=vim" >> ${BASHRC_PATH}

echo "Done."

