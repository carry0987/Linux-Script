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
* [***GCP***](#GCP)
  * [gcp-setup.sh](#gcp-setupsh)
  * [gcp-pkg.sh](#gcp-pkgsh)
* [***Proxy***](#Proxy)
  * [ssr.sh](#ssrsh)
* [***Server***](#Server)
  * [bbr.sh](#bbrsh)
* [***System***](#System)
  * [swap.sh](#swapsh)

## Tools
### tools.sh
- Description: Regular Command
- Support OS: Debian 6+ / Ubuntu 14+

#### Installation:
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/Tools/tools.sh && chmod +x tools.sh && bash tools.sh
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/Tools/tools.sh && chmod +x tools.sh && bash tools.sh
```

---
## GCP
### gcp-setup.sh
- Description: Run this script to setup gcp environment
- Support OS: Debian 6+ / Ubuntu 14+

#### Installation:
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/GCP/gcp-setup.sh && chmod +x gcp-setup.sh && bash gcp-setup.sh
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/GCP/gcp-setup.sh && chmod +x gcp-setup.sh && bash gcp-setup.sh
```

### gcp-pkg.sh
- Description: Install main packages for gcp
- Support OS: Debian 6+ / Ubuntu 14+

#### Installation:
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/GCP/gcp-pkg.sh && chmod +x gcp-pkg.sh && bash gcp-pkg.sh
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/GCP/gcp-pkg.sh && chmod +x gcp-pkg.sh && bash gcp-pkg.sh
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
## Common Setting
### .bashrc
```bash
alias ll='ls -l'
alias la='ls -a'
alias tt='sudo sh tools.sh'
alias sr='screen -r'
```

### .vimrc
```bash
set nu
set tabstop=4
set expandtab
set mouse=a
set cursorline
set viminfo+=n~/.vim/viminfo
syntax on
```
