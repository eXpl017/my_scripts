#!/bin/bash

set -e

if ( ! command -v tmux ); then
    echo "Tmux not available, installing..."
    sudo apt-get -qq -y install tmux
else
    echo "Tmux available, proceeding..."
fi

echo "Checking availability of .config directory"
if [[ ! -d ${HOME}/.config ]]; then
    echo "Counldn't find directory, creating..."
    mkdir ${HOME}/.config
    echo "Done"
else
    echo "Directory found, proceeding..."
fi

echo "Exporting XDG_CONFIG_HOME as ${HOME}/.config"
echo "export XDG_CONFIG_HOME=${HOME}/.config" >> ${HOME}/.profile}

echo "Getting tpm"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Fetching my tmux config"
git clone git@github.com:eXpl017/tmuxConfig.git ~/tmuxConfig

echo "Copying config files"
cp ~/tmuxConfig/tmux.conf ${XDG_CONFIG_HOME}/tmux/tmux.conf

cat << 'EOF'
To apply config and install plugins:
    - start a tmux session, configs are applied
    - in the tmux session, open the tmux.conf file
      use `Prefix + I` to install plugins
EOF
