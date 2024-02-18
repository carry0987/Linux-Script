#!/bin/bash

set -e

# Function to wrap commands with sudo if not running as root
execute() {
    if [ "$(id -u)" != "0" ]; then
        sudo "$@"
    else
        "$@"
    fi
}

execute apt-get update
execute apt-get -y dist-upgrade
execute apt-get -y install ssh zip unzip wget vim screen haveged htop ufw
execute apt-get clean
# Start SSH
execute systemctl enable ssh --now
execute systemctl start ssh
# Start haveged
execute systemctl enable haveged
execute systemctl start haveged
# Change default editor to vim
execute update-alternatives --set editor /usr/bin/vim.basic

echo 'Finish !'
exit 0
