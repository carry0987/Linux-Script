#!/bin/bash

set -e
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install zip unzip wget vim screen haveged htop
sudo apt-get clean
#Start haveged
sudo systemctl enable haveged
sudo systemctl start haveged

echo 'Finish !'
exit 0
