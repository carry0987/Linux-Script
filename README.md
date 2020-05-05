# Linux-Script
Store linux script

## Script List
* [***Proxy***](#Proxy)
  * [ssr.sh](#ssrsh)
* [***Server***](#Server)
  * [bbr.sh](#bbrsh)
* [***System***](#System)
  * [swap.sh](#swapsh)

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
``` bash
wget -N --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/SSR/ssr.sh && chmod +x ssr.sh && bash ssr.sh
```

---
## Server
### bbr.sh
- Description: BBR Easy Setup Tool
- Support OS: Debian 6+ / Ubuntu 14+

#### Installation:
``` bash
wget -N --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/BBR/bbr.sh && chmod +x bbr.sh && bash bbr.sh
```

---
## System
### swap.sh
- Description: Swap Easy Setup Tool
- Support OS: Debian 6+ / Ubuntu 14+

#### Installation:
``` bash
wget -N --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/Swap/swap.sh && chmod +x swap.sh && bash swap.sh
```
