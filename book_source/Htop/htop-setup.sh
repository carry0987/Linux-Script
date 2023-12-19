#!/bin/bash
set -e

make_htoprc(){
    if [[ -f $1'htoprc' ]]; then
        rm -f "$1"'htoprc'
    fi
    wget -P "$1" 'https://raw.githubusercontent.com/carry0987/Linux-Script/master/book_source/Htop/htoprc'
}

# Setup htop colorscheme
read -erp "Please enter the username, leave blank if you want to setup htop for root : " username
if [[ -z $username || $username == 'root' ]]; then
    if [[ $EUID != 0 ]]; then
        # Replaced 'su root' with 'exec sudo bash' to fix SC2117 and maintain the rest of the script flow
        exec sudo bash "$0" "$@"
        # The script will be re-executed with root privileges and then exit, so the following lines under this condition won't be executed again
        exit $?
    fi
    set_user='root'
    work_path='/'$set_user'/.config/htop/'
else
    set_user=$username
    work_path='/home/'$set_user'/.config/htop/'
fi

# Check if the directory exist before accessing it
if [[ ! -d "$work_path" ]]; then
    mkdir -p "$work_path"
fi
cd "$work_path"
make_htoprc "$work_path"'/'

exit 0
