#!/bin/bash

set -e
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install zip unzip wget vim screen exfat-fuse haveged
sudo apt-get clean

echo 'Finish !'
exit 0
