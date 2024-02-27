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

# Install qemu-guest-agent
install_guest_agent() {
    echo -e 'Install qemu-guest-agent'
    read -p "Do you want to install qemu-guest-agent? (y/n) " -r install_ga
    if [[ ${install_ga} == "n" || ${install_ga} == "N" ]]; then
        echo -e "[Info] qemu-guest-agent installation has been canceled..."
        return 0
    fi
    execute apt-get -y install qemu-guest-agent
    systemctl start qemu-guest-agent
}

execute apt-get update
execute apt-get -y dist-upgrade
execute apt-get -y install ssh zip unzip wget vim screen haveged htop ufw
# Install qemu-guest-agent
install_guest_agent
# Clean up
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
