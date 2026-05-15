#!/bin/bash

set -e
# set -x

##### VAR DECLARATION #####

# height and width of terminal window are stored in $LINES and $COLUMNS
BASHRC_PATH=${USER_HOME}/.bashrc


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
declare -a tools_to_install=(curl xclip tmux vim jq yq ripgrep)
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


##### BASHRC CHANGES #####

echo "[+] Making required changes to bashrc..."

# setting vim as default editor
echo "VISUAL=vim" >> ${BASHRC_PATH}
echo "EDITOR=vim" >> ${BASHRC_PATH}

echo "Done."
