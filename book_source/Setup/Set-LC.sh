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

execute ln -fs /bin/bash /bin/sh
execute timedatectl set-ntp yes

#Check operating user
check_user=$EUID
user_name=$USER
if [ $check_user -eq 0 ]; then
    read -e -p 'Where is your .bashrc file? /home/>' -r select_user
    sed -i '/HISTCONTROL/s/.*/HISTCONTROL=ignoreboth:erasedups/' "/home/${select_user}/.bashrc"
    source "/home/${select_user}/.bashrc"
else
    sed -i '/HISTCONTROL/s/.*/HISTCONTROL=ignoreboth:erasedups/' "/home/${user_name}/.bashrc"
    source "/home/${user_name}/.bashrc"
fi

#Reboot
reboot_os() {
    echo
    read -p "Do you want to restart system? [y/n]>" -r is_reboot
    if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
        secs=$((5))
        while [[ $secs -gt 0 ]]
        do
            echo -ne 'Wait '"$secs\033[0K"' seconds to reboot'"\r"
            sleep 1
            : $((secs--))
        done
        execute reboot
    else
        echo -e "[Info] Reboot has been canceled..."
        exit 0
    fi
}

#Set up locale
language='C.UTF-8'
execute rm /etc/default/locale
echo "LANG=$language
LANGUAGE=$language
LC_ALL=$language
LC_CTYPE=$language" | execute tee /etc/default/locale > /dev/null
execute chmod 644 /etc/default/locale
export LANG="${language}"
export LANGUAGE="${language}"
export LC_ALL="${language}"
export LC_CTYPE="${language}"
echo '#####################'
execute cat /etc/default/locale
echo '#####################'
reboot_os
