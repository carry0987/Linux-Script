#!/bin/bash
set -e

make_vim_folder(){
    if [[ ! -d  $1'.vim' || ! -d  $1'.vim/colors' ]]; then
        mkdir -p '.vim/colors'
    fi
    if [[ ! -f $1'.vim/colors/monokai.vim' ]]; then
        wget -P $1'.vim/colors' 'https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim'
    fi
}

make_vimrc(){
    if [[ -f $1'.vimrc' ]]; then
        echo 'syntax on' >> $1'.vimrc'
        echo 'colorscheme monokai' >> $1'.vimrc'
    else
        wget -P $1 'https://raw.githubusercontent.com/carry0987/Linux-Script/master/Vim/.vimrc'
    fi
}

# Setup vim colorscheme
read -e -p "Please enter the username, leave blank if you want to setup vim for root : " username
if [[ -z $username || $username == 'root' ]]; then
    if [[ $EUID != 0 ]]; then
        su 'root'
    fi
    set_user='root'
    cd '/'$set_user
else
    set_user=$username
    cd '/home/'$set_user
fi

make_vim_folder '/home/'$set_user'/'
make_vimrc '/home/'$set_user'/'

exit 0
