## qBittorrent Setup

### Install qBittorrent on Ubuntu
#### Import qBittorrent PPA on Ubuntu
In this section, we’ll import the qBittorrent Launchpad PPA (Personal Package Archive) to access the qBittorrent packages for Ubuntu.

Step 1: Update Ubuntu Before qBittorrent Installation
```bash
sudo apt update && sudo apt upgrade -y
```

Step 2: Install Initial Packages For qBittorrent on Ubuntu
```bash
sudo apt install dirmngr ca-certificates software-properties-common apt-transport-https
```

Step 3: Import qBittorrent PPA on Ubuntu  
**Option 1: Import qBittorrent stable PPA:**
```bash
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
```

**Option 2: Import qBittorrent unstable PPA:**
```bash
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-unstable -y
```

Step 4: Update Packages List After qBittorrent PPA Import on Ubuntu
```bash
sudo apt update
```

#### Install qBittorrent Desktop Client
In this section, we’ll install the qBittorrent desktop client on your Ubuntu system and launch it for the first time.  

Step 1: Install qBittorrent Desktop Client via APT command
```bash
sudo apt install qbittorrent
```

Step 2: Launch qBittorrent Desktop Client
```bash
qbittorrent
```

#### Install qBittorrent-nox Web-UI (Ubuntu Server)
qBittorrent-nox allows you to install qBittorrent on a headless Ubuntu server or a remotely accessed desktop. With the WebUI interface, you can efficiently manage qBittorrent using your favorite browser.

Step 1: Install qBittorrent-nox via APT command
```bash
sudo apt install qbittorrent-nox
```
qBittorrent-nox is designed for headless clients and is accessible via a Web interface at the default localhost location: `http://localhost:8080`. The Web UI access is secured by default.  
The default username is `admin`, and the default password is `adminadmin`.  

Step 2: Create a User and Group for qbittorrent-nox on Ubuntu
```bash
sudo adduser qbtuser
```

Step 3: Disable qbtuser account SSH login (optional)  
You may also want to disable login for the account (from SSH) for security reasons. The account will still be usable locally:
```bash
sudo usermod -s /usr/sbin/nologin qbtuser
```
This can be reversed if necessary with the command:
```bash
sudo usermod -s /bin/bash qbtuser
```

Step 4: Add Username to qBittorrent Group on Ubuntu
```bash
sudo adduser $USER qbtuser
```

Step 5: Configure a Systemd Service File for qbittorrent-nox on Ubuntu  
Modify a systemd service file for qbittorrent-nox:
```bash
sudo vim /usr/lib/systemd/system/qbittorrent-nox@.service
```
Copy and paste the following lines into the file:
```bash
[Unit]
Description=qBittorrent-nox service for user %I
Documentation=man:qbittorrent-nox(1)
Wants=network-online.target
After=local-fs.target network-online.target nss-lookup.target

[Service]
Type=forking
PrivateTmp=false
User=%i
Group=%i
UMask=007
ExecStart=/usr/bin/qbittorrent-nox -d --webui-port=8080
TimeoutStopSec=1800
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Step 6: Reload the Systemd Daemon for qbittorrent-nox on Ubuntu
```bash
sudo systemctl daemon-reload
```

Step 7: Start and Enable qbittorrent-nox Service on Ubuntu
```bash
sudo systemctl start qbittorrent-nox@qbtuser
sudo systemctl enable qbittorrent-nox@qbtuser
```
Before proceeding, check the status to ensure everything is working correctly:
```bash
sudo systemctl status qbittorrent-nox@qbtuser
```
