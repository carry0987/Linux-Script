# Linux-Script
Store Linux Script

## Info
Please run the script with root user, to change to root user, use the below command
```
su root
```

## Script List
* [***Tools***](#Tools)
  * [tools.sh](#toolssh)
* [***Setup***](#Setup)
  * [Set-LC.sh](#Set-LCsh)
  * [Install-Main-Pkg.sh](#Install-Main-Pkgsh)
* [***Vim***](#Vim)
  * [vim-setup](#vim-setupsh)
* [***Docker***](#Docker)
  * [Docker-Set](Docker/docker.md)
  * [Portainer](Docker/portainer.md)
* [***Server***](#Server)
  * [bbr.sh](#bbrsh)
* [***System***](#System)
  * [swap.sh](#swapsh)
* [***Proxy***](#Proxy)
  * [ssr.sh](#ssrsh)
  * [vpn.sh](#vpnsh)

## Tools
### tools.sh
- Description: Regular Command
- Support OS: Debian 6+ / Ubuntu 14+

#### Installation:
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/Tools/tools.sh && chmod +x tools.sh && mv -v tools.sh /usr/local/bin/tools && bash tools
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/Tools/tools.sh && chmod +x tools.sh && mv -v tools.sh /usr/local/bin/tools && bash tools
```

---
## Setup
### Set-LC.sh
- Description: Run this script to setup default environment
- Support OS: Debian 6+ / Ubuntu 14+

#### Installation:
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/Setup/Set-LC.sh && chmod +x Set-LC.sh && bash Set-LC.sh
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/Setup/Set-LC.sh && chmod +x Set-LC.sh && bash Set-LC.sh
```

### Install-Main-Pkg.sh
- Description: Install main packages for new server
- Support OS: Debian 6+ / Ubuntu 14+

#### Installation:
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/Setup/Install-Main-Pkg.sh && chmod +x Install-Main-Pkg.sh && bash Install-Main-Pkg.sh
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/Setup/Install-Main-Pkg.sh && chmod +x Install-Main-Pkg.sh && bash Install-Main-Pkg.sh
```

---
## Vim
### vim-setup.sh
- Description: Run this script to setup vim config

#### Installation:
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/Vim/vim-setup.sh && chmod +x vim-setup.sh && bash vim-setup.sh
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/Vim/vim-setup.sh && chmod +x vim-setup.sh && bash vim-setup.sh
```

---
## Server
### bbr.sh
- Description: BBR Easy Setup Tool
- Support OS: Debian 6+ / Ubuntu 14+

#### Installation:
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/BBR/bbr.sh && chmod +x bbr.sh && bash bbr.sh
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/BBR/bbr.sh && chmod +x bbr.sh && bash bbr.sh
```

---
## System
### swap.sh
- Description: Swap Easy Setup Tool
- Support OS: Debian 6+ / Ubuntu 14+

#### Installation:
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/Swap/swap.sh && chmod +x swap.sh && bash swap.sh
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/Swap/swap.sh && chmod +x swap.sh && bash swap.sh
```

---
## Proxy
### ssr.sh
- Description: ShadowsocksR Easy Setup Tool
- Support OS: CentOS 6+ / Debian 6+ / Ubuntu 14+

#### Feature:
- Support setting limit of user speed
- Support setting limit of the number of port devices
- Support displaying current connected IP
- Support displaying SS / SSR connection info & QRcode
- Support switching single-port / multi-port mode
- Support easy installation of BBR

#### Note
If you want to get location of IP, you should get the token from [IP-Info](https://ipinfo.io/)

#### Installation:
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/SSR/ssr.sh && chmod +x ssr.sh && bash ssr.sh
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/SSR/ssr.sh && chmod +x ssr.sh && bash ssr.sh
```

### vpn.sh
- Description: IPsec VPN Easy Setup Tool
- Support OS: Debian 9+ / Ubuntu 14+

#### Installation:
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/VPN/vpn.sh && chmod +x vpn.sh && bash vpn.sh
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/VPN/vpn.sh && chmod +x vpn.sh && bash vpn.sh
```

---
## Common Setting
### .bashrc
```bash
alias ll='ls -lh'
alias la='ls -a'
alias tt='sudo sh tools'
alias sr='screen -r'
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

---
## Hint
If `bash: command not found`
```bash
export PATH="$PATH:/sbin:/usr/sbin:usr/local/sbin"
```
