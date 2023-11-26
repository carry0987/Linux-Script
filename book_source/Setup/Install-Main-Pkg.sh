#!/bin/bash

set -e
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y install ssh zip unzip wget vim screen haveged htop ufw
sudo apt-get clean
# Start SSH
sudo systemctl enable ssh --now
sudo systemctl start ssh
# Start haveged
sudo systemctl enable haveged
sudo systemctl start haveged
# Change default editor to vim
sudo update-alternatives --set editor /usr/bin/vim.basic

echo 'Finish !'
exit 0
