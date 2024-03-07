#!/usr/bin/env bash

set -e

# Set variable
repo_url='https://raw.githubusercontent.com/carry0987/Linux-Script/master/book_source/qBittorrent/conf/qBittorrent-conf.zip'
red='\033[0;31m'
green='\033[0;32m'
plain='\033[0m'
cur_dir=$(pwd)

# Set font prefix
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="[${green}Info${plain}]"
Error="[${red}Error${plain}]"

# Check root
[[ $EUID -ne 0 ]] && echo -e "${Error} This script must be run as root!" && exit 1

# Download and unzip qBittorrent configuration files
Download_qBittorrent_conf(){
    echo -e "${Info} Downloading qBittorrent configuration files..."
    wget --no-check-certificate --no-cache --no-cookies -O qBittorrent-conf.zip "${repo_url}"
    if [[ -s "qBittorrent-conf.zip" ]]; then
        read -ep "Please enter the username, leave blank if you want to setup for qbtuser : " -r username
        if [[ -z $username || $username == 'qbtuser' ]]; then
            username='qbtuser'
        fi
        unzip -o qBittorrent-conf.zip -d "/home/${username}/.config"
        chmod -R 755 "/home/${username}/.config/qBittorrent"
        chown -R "${username}":"${username}" "/home/${username}/.config/qBittorrent"
        echo -e "${Info} qBittorrent configuration files have been downloaded and unzipped successfully!"
    else
        echo -e "${Error} Failed to download qBittorrent configuration files!"
    fi
}

Download_qBittorrent_conf

exit 0
