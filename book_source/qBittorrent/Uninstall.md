## qBittorrent Uninstall

### Uninstall qBittorrent on Ubuntu
#### Remove qBittorrent or qBittorrent-nox From Ubuntu
If you wish to uninstall qBittorrent, follow this simple process. First, remove the custom PPA if you installed it according to the previous tutorial.  
To remove the PPA you imported, use the following commands:
**Remove qBittorrent stable PPA:**  
```bash
sudo add-apt-repository --remove ppa:qbittorrent-team/qbittorrent-stable -y
```
**Remove qBittorrent unstable PPA:**  
```bash
sudo add-apt-repository --remove ppa:qbittorrent-team/qbittorrent-unstable -y
```
Now, remove the qBittorrent package:
```bash
sudo apt remove qbittorrent qbittorrent-nox -y
```
Finally, remove the residual configuration files:
```bash
sudo apt purge qbittorrent qbittorrent-nox -y
```

#### Remove qBittorrent Data and Configuration Files
To remove the qBittorrent data and configuration files, use the following commands:
```bash
rm -rf ~/.config/qBittorrent
rm -rf ~/.local/share/data/qBittorrent
```

#### Remove qBittorrent User and Group
To remove the qBittorrent user and group, use the following commands:
```bash
sudo deluser --remove-home qbtuser
```

#### Remove qBittorrent Log Files
To remove the qBittorrent log files, use the following commands:
```bash
sudo rm -rf /var/log/qbittorrent
```

#### Remove qBittorrent Systemd Service
To remove the qBittorrent systemd service, use the following commands:
```bash
sudo systemctl stop qbittorrent-nox
sudo systemctl disable qbittorrent-nox
sudo rm /etc/systemd/system/qbittorrent-nox.service
sudo systemctl daemon-reload
sudo systemctl reset-failed
```

#### Remove qBittorrent-nox Web-UI
To remove the qBittorrent-nox Web-UI, use the following commands:
```bash
sudo rm -rf /usr/share/qbittorrent-nox
```

#### Remove qBittorrent-nox Configuration Files
To remove the qBittorrent-nox configuration files, use the following commands:
```bash
sudo rm -rf /etc/qBittorrent
```

#### Remove qBittorrent-nox User and Group
To remove the qBittorrent-nox user and group, use the following commands:
```bash
sudo deluser --remove-home qbtuser
```

#### Remove qBittorrent-nox Log Files
To remove the qBittorrent-nox log files, use the following commands:
```bash
sudo rm -rf /var/log/qbittorrent-nox
```

#### Remove qBittorrent-nox Systemd Service
To remove the qBittorrent-nox systemd service, use the following commands:
```bash
sudo systemctl stop qbittorrent-nox
sudo systemctl disable qbittorrent-nox
sudo rm /etc/systemd/system/qbittorrent-nox@.service
sudo systemctl daemon-reload
sudo systemctl reset-failed
```
