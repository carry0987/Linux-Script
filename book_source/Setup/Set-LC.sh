#!/bin/bash

set -e

sudo ln -fs /bin/bash /bin/sh
sudo timedatectl set-ntp yes

#Check operating user
check_user=$EUID
user_name=$USER
if [ $check_user -eq 0 ]; then
    read -e -p 'Where is your .bashrc file? /home/>' select_user
    sed -i '/HISTCONTROL/s/.*/HISTCONTROL=ignoreboth:erasedups/' /home/${select_user}/.bashrc
    source /home/${select_user}/.bashrc
else
    sed -i '/HISTCONTROL/s/.*/HISTCONTROL=ignoreboth:erasedups/' /home/${select_user}/.bashrc
    source /home/${user_name}/.bashrc
fi

#Reboot
reboot_os() {
    echo
    read -p "Do you want to restart system? [y/n]>" is_reboot
    if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
        secs=$((5))
        while [ $secs -gt 0 ]
        do
            echo -ne 'Wait '"$secs\033[0K"' seconds to reboot'"\r"
            sleep 1
            : $((secs--))
        done
        sudo reboot
    else
        echo -e "[Info] Reboot has been canceled..."
        exit 0
    fi
}

#Set up locale
language='C.UTF-8'
sudo rm /etc/default/locale
sudo touch /etc/default/locale
sudo chmod 644 /etc/default/locale
sudo echo 'LANG='$language >> /etc/default/locale
sudo echo 'LANGUAGE='$language >> /etc/default/locale
sudo echo 'LC_ALL='$language >> /etc/default/locale
sudo echo 'LC_CTYPE='$language >> /etc/default/locale
export LANG="${language}"
export LANGUAGE="${language}"
export LC_ALL="${language}"
export LC_CTYPE="${language}"
echo '#####################'
sudo cat /etc/default/locale
echo '#####################'
reboot_os
