# Docker

## Install
Follow `Docker Installation Guide` via this **[link](https://docs.docker.com/engine/install/ubuntu/)**

## Setup
1. Start docker-client and set automatically start on boot
```bash
sudo systemctl start docker && sudo systemctl enable docker
```

2. Configure the current user to operate docker commands without sudo (Recommended)
```bash
sudo groupadd docker
```
```bash
sudo usermod -aG docker $USER
```

## Docker-compose
1. Download the corresponding Linux version of Docker-compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-$(uname -s)-$(uname -m)" \
          -o /usr/local/bin/docker-compose
```

2. Give execute permission
```bash
sudo chmod +x /usr/local/bin/docker-compose
```
