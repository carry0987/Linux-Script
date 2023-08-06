## Vim
### vim-setup.sh
- Description: Run this script to setup vim config

#### Installation:
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/book_resource/Vim/vim-setup.sh && chmod +x vim-setup.sh && bash vim-setup.sh
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/book_resource/Vim/vim-setup.sh && chmod +x vim-setup.sh && bash vim-setup.sh
```

### .vimrc
```bash
set nu
set ai
set shiftwidth=4
set tabstop=4
set expandtab
set mouse=a
set cursorline
set hlsearch
set viminfo+=n~/.vim/viminfo
set t_Co=256
set encoding=utf8
syntax on
```
