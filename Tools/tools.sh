#!/usr/bin/env bash

#=================================================
#   System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#   Description: Regular Command
#   Version: 1.0.5
#   Author: carry0987
#   Web: https://github.com/carry0987
#=================================================

set -e

#Set variable
sh_ver='1.0.5'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
cur_dir=$(pwd)
#Set font prefix
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="[${green}Info${plain}]"
Error="[${red}Error${plain}]"

[[ $EUID -ne 0 ]] && echo -e "${Error} This script must be run as root!" && exit 1

#Update script
Update_Script(){
    sh_new_ver=$(wget --no-check-certificate -qO- -t1 -T3 "https://raw.githubusercontent.com/carry0987/Linux-Script/master/Tools/tools.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1) && sh_new_type='github'
    [[ -z ${sh_new_ver} ]] && echo -e "${Error} Cannot connect to Github !" && exit 0
    wget -N --no-check-certificate "https://raw.githubusercontent.com/carry0987/Linux-Script/master/Tools/tools.sh"
    echo -e "The script is up to date [ ${sh_new_ver} ] !(Note: Because the update method is to directly overwrite the currently running script, some errors may be prompted below, just ignore it)" && exit 0
}

if [[ -n $1 && $1 =~ ^[0-9]+$ ]]; then
    tool=$1
fi

if [[ ! -n $tool ]]; then
    echo -e "Regular Command ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
---- carry0987 | github.com/carry0987/Linux-Script/ ----
    "
    echo '1) Download files (link)'
    echo '2) Download files (list)'
    echo '3) Count Files'
    echo '4) Delete File Or Folder'
    echo '5) Check Crontab status'
    echo '6) Check TCP-BBR'
    echo '7) Update Packages'
    echo '8) Install Packages'
    echo '9) Check Kernal version'
    echo '10) Resource Monitor (Sort By CPU)'
    echo '11) Resource Monitor (Sort By Memory)'
    echo '12) Estimate Usage Of Folder'
    echo '13) Update Script'
    echo '14) Exit'
    read -p 'Which tool do you want to use ? ' tool
fi

DEFAULT_PATH=''

#Detect tools
case $tool in
    1)
        read -p 'Please enter your link>' link
        if [[ -z $DEFAULT_PATH ]]; then
            read -e -p 'Please enter the path that you want to save this file, or just leave blank if you want to save to current path>' download_path
        else
            download_path=$DEFAULT_PATH
        fi
        if [ -z $download_path ]; then
            wget --content-disposition $link
        else
            wget -P $download_path --content-disposition $link
        fi
        ;;
    2)
        read -e -p 'Please enter your path of link list>' link_list
        if [[ -z $DEFAULT_PATH ]]; then
            read -e -p 'Please enter the path that you want to save this file, or just leave blank if you want to save to current path>' download_list_path
        else
            download_list_path=$DEFAULT_PATH
        fi
        if [ -z $download_list_path ]; then
            wget --content-disposition -i $link_list
        else
            wget -P $download_list_path --content-disposition -i $link_list
        fi
        ;;
    3)
        read -e -p 'Enter your path>' count_path
        find $count_path -type f |wc -l
        ;;
    4)
        read -e -p 'Enter file or folder that you want to remove>' file_or_folder
        read -p 'Do you really want to remove '$file_or_folder' ? [Y/N]' var
        if [[ $var =~ ^([Yy])+$ ]]; then
            rm -vRf $file_or_folder
        elif [[ $var =~ ^([Nn])+$ ]]; then
            bash tools.sh
        else
            echo 'You can only choose yes or no'
        fi
        ;;
    5)
        /etc/init.d/cron status
        ;;
    6)
        #Check User
        if [[ !$EUID -ne 0 ]]; then
            echo '######################'
            echo 'TCP-BBR Status'
            echo '######################'
            sudo sysctl -p
            sudo sysctl net.ipv4.tcp_available_congestion_control
            echo '######################'
        else
            echo -e "${Error} This script must be run as root!" && exit 1
        fi
        ;;
    7)
        #Check User
        if [[ !$EUID -ne 0 ]]; then
            apt-get update
            apt-get dist-upgrade
            apt-get clean
        else
            sudo apt-get update
            sudo apt-get dist-upgrade
            sudo apt-get clean
        fi
        ;;
    8)
        read -p 'Please enter the packages name that you want to install>' pkg_name
        if [ -z $pkg_name ]; then
            echo 'The package name is empty !'
            exit 0
        fi
        #Check User
        if [[ !$EUID -ne 0 ]]; then
            apt-get update
            apt-get dist-upgrade
            apt-get clean
            apt-get install $pkg_name
        else
            sudo apt-get update
            sudo apt-get dist-upgrade
            sudo apt-get clean
            sudo apt-get install $pkg_name
        fi
        ;;
    9)
        uname -a
        #rpi-update
        #secs=$((5))
        #while [ $secs -gt 0 ]
        #do
        #    echo -ne 'Wait '"$secs\033[0K"' seconds to reboot'"\r"
        #    sleep 1
        #    : $((secs--))
        #done
        #reboot
        ;;
    10)
        ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head
        ;;
    11)
        ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head
        ;;
    12)
        read -e -p 'Please enter the folder that you want to estimate usage of>' estimate_folder
        if [[ -z $estimate_folder ]]; then
            echo 'You must type the folder path !'
        else
            count_estimate_folder=${estimate_folder%/}
            du -sch $count_estimate_folder
        fi
        ;;
    13)
        Update_Script
        ;;
    14 | 'q')
        echo 'Exited'
        ;;
    *)
        echo 'Tools not supported'
        ;;
esac

exit 0
