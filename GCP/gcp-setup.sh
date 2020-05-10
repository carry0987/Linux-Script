#!/bin/bash

set -e

sudo ln -fs /bin/bash /bin/sh
sudo timedatectl set-ntp yes

# Check operating user
check_user=$USER
if [ $check_user == 'root' ]; then
    read -e -p 'Where is your .bashrc file? /home/>' select_user
    sed -i 's/HISTCONTROL=ignoreboth/HISTCONTROL=ignoreboth:erasedups/g' /home/${select_user}/.bashrc
fi

#Set up locale
language='C.UTF-8'
sudo rm /etc/default/locale
sudo touch /etc/default/locale
sudo chmod 644 /etc/default/locale
sudo echo 'LANG='$language >> /etc/default/locale
sudo echo 'LANGUAGE='$language >> /etc/default/locale
sudo echo 'LC_ALL='$language >> /etc/default/locale
sudo echo 'LC_CTYPE='$language >> /etc/default/locale
echo '#####################'
sudo cat /etc/default/locale
echo '#####################'
echo 'Wait 5 seconds to reboot...'
sleep 5
sudo reboot
