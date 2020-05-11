#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#   System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#   Description: Add Swap And Tuning
#   Version: 1.0.6
#   Author: carry0987
#   Web: https://github.com/carry0987
#=================================================

sh_ver='1.0.6'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
cur_dir=$(pwd)
fstab='/etc/fstab'
sysctl='/etc/sysctl.conf'
#Set var
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="[${green}Info${plain}]"
Error="[${red}Error${plain}]"

[[ $EUID -ne 0 ]] && echo -e "${Error} This script must be run as root!" && exit 1

current_swap=$(free -m | awk '/^Swap:/ { print $2 }')

#Update script
Update_Script(){
    sh_new_ver=$(wget --no-check-certificate -qO- -t1 -T3 "https://raw.githubusercontent.com/carry0987/Linux-Script/master/Swap/swap.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1) && sh_new_type='github'
    [[ -z ${sh_new_ver} ]] && echo -e "${Error} Cannot connect to Github !" && exit 0
    wget -N --no-check-certificate "https://raw.githubusercontent.com/carry0987/Linux-Script/master/Swap/swap.sh"
    echo -e "The script is up to date [ ${sh_new_ver} ] !(Note: Because the update method is to directly overwrite the currently running script, some errors may be prompted below, just ignore it)" && exit 0
}

#Display current status
display_status(){
    #Check if swap file exists
    if [[ ${current_swap} == "0" ]]; then
        echo -e "${Info} Current Status: ${red}Swap Disabled${plain}"
    else
        echo -e "${Info} Current Status: ${green}Swap Enabled${plain}"
        echo -e "${Info} Swap Size: ${current_swap} MB"
    fi 
}

#Set Swap
Set_Swap(){
    echo 'Please enter the size of SWAP (MB)'
    read -p 'Default: 1024 MB>' get_size
    if [[ -z ${get_size} ]]; then
        swap_size=1024
    else
        echo -e 'Set Swap Size to '${get_size}
        swap_size=${get_size}
    fi
    #Check Swapon
    if ! [ -x "$(command -v swapon)" ]; then
        echo 'swapon is not installed, start downloading...' >&2
        apt-get update
        apt-get dist-upgrade
        apt-get install swapon
    fi
    dd if=/dev/zero of=/swapfile bs=1M count=${swap_size}
    mkswap -f /swapfile
    chmod 0600 /swapfile
    swapon /swapfile
    free -m
    if ! [ "$(grep -q '/swapfile' ${fstab})" ];then
        echo '/swapfile none swap sw 0 0' >> ${fstab}
    else
        echo 'fstab already setted'
    fi
    if ! [ "$(grep -q 'vm.swappiness' ${sysctl})" ];then
        echo 'vm.swappiness=50' >> ${sysctl}
    else
        echo 'vm.swappiness already setted'
    fi
    if ! [ "$(grep -q 'vm.vfs_cache_pressure' ${sysctl})" ];then
        echo 'vm.vfs_cache_pressure=50' >> ${sysctl}
    else
        echo 'vm.vfs_cache_pressure already setted'
    fi
}

#Modify Swap
Modify_Swap(){
    #Check Swapon
    if ! [ -x "$(command -v swapon)" ]; then
        echo -e 'swapon is not installed, start downloading...' >&2
        apt-get update
        apt-get dist-upgrade
        apt-get install swapon
    fi
    swapoff /swapfile
    Set_Swap
}

#View Swap Status
View_Swap_Status(){
    swapon -s
}

#Remove Swap
Remove_Swap(){
    #Check Swapon
    if ! [ -x "$(command -v swapon)" ]; then
        echo -e 'swapon is not installed, start downloading...' >&2
        apt-get update
        apt-get dist-upgrade
        apt-get install swapon
    fi
    swapoff /swapfile
    if ! [ grep -q '/swapfile' ${fstab} ];then
        sed '\|^/swapfile|d' ${fstab}
        echo 'fstab-swap deleted'
    fi
    if ! [ grep -q 'vm.swappiness' ${sysctl} ];then
        sed '\|^vm.swappiness|d' ${sysctl}
        echo 'vm.swappiness deleted'
    fi
    if ! [ grep -q 'vm.vfs_cache_pressure' ${sysctl} ];then
        sed '\|^vm.vfs_cache_pressure|d' ${sysctl}
        echo 'vm.vfs_cache_pressure deleted'
    fi
    echo -e "${Info} You should reboot system by yourself"
}

clear
echo -e "  Swap Easy Setup ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- carry0987 | github.com/carry0987/Linux-Script/ ----
  "
echo '1) Set Swap'
echo '2) Modify Swap'
echo '3) Update script'
echo '4) View Swap Status'
echo '5) Remove Swap'
echo '6) Exit'

display_status
echo && read -e -p 'Please enter the number [1-6]：' num

case $num in
    1)
    Set_Swap
    ;;
    2)
    Modify_Swap
    ;;
    3)
    Update_Script
    ;;
    4)
    View_Swap_Status
    ;;
    5)
    Remove_Swap
    ;;
    6)
    echo 'Canceled'
    exit 0
    ;;
    *)
    echo -e ${Error}' Please enter correct number [1-6]'
    ;;
esac

#"if": input file
#"of": represents output file
#"bs": specifies the block size for the both the input and output file
#"count": blocks
