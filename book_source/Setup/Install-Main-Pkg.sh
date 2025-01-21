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

# Check if the custom sudoers file exists, and create/overwrite it
create_nopasswd_sudoers() {
    echo "Checking for no-password sudo configuration..."
    read -p "Do you want to create no-password sudo configuration for the sudo group? (y/n) " -r create_nopasswd
    if [[ ${create_nopasswd} != "y" && ${create_nopasswd} != "Y" ]]; then
        echo -e "[Info] No-password sudo configuration has been canceled..."
        return 0
    fi
    if [ ! -f /etc/sudoers.d/nopasswd ]; then
        echo "Creating no-password sudo configuration for the sudo group."
        echo "%sudo	ALL=(ALL:ALL) NOPASSWD:ALL" | execute tee /etc/sudoers.d/nopasswd > /dev/null
        # Ensure the file has the correct permissions
        execute chmod 0440 /etc/sudoers.d/nopasswd
        echo "The sudo group can now use sudo without a password."
    else
        echo "No-password sudo configuration already exists."
    fi
}

execute apt-get update
execute apt-get -y dist-upgrade
execute apt-get -y install ssh zip unzip wget vim screen haveged htop ufw tree
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
# Configure sudo to not require password for current user
create_nopasswd_sudoers

echo 'Finish !'
exit 0
