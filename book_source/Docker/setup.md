## Docker

### Install
Follow `Docker Installation Guide` via this **[LINK](https://docs.docker.com/engine/install/ubuntu/)**

### Setup
1. Start docker-client and set automatically start on boot
```bash
sudo systemctl start docker && sudo systemctl enable docker
```

### Run Docker Without Sudo
You can set up the Docker daemon to run without root privileges. This is a good way to avoid using `sudo` when you use the `docker` command.  
Directly use the following script for a quick setup, or follow the steps below for manual operation.  

#### Quick Setup
WGET
``` bash
wget -N --no-cache --no-check-certificate https://raw.githubusercontent.com/carry0987/Linux-Script/master/book_source/Docker/docker-setup.sh && chmod +x docker-setup.sh && bash docker-setup.sh
```
CURL
```bash
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/carry0987/Linux-Script/master/book_source/Docker/docker-setup.sh && chmod +x docker-setup.sh && bash docker-setup.sh
```

#### Manual Setup
1. Add **`docker`** group
```bash
sudo groupadd docker
```

2. Add current user into **`docker`** group
```bash
sudo usermod -G docker -a $USER
```

3. Refresh group list
```bash
newgrp docker
```

4. Check group
```bash
groups
```

5. Restart **`docker`** service
```bash
sudo systemctl restart docker
```

6. Test Docker without sudo
```bash
docker info
```

### Docker-compose (Optional)
1. Download the corresponding Linux version of Docker-compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-$(uname -s)-$(uname -m)" \
          -o /usr/local/bin/docker-compose
```

2. Give execute permission
```bash
sudo chmod +x /usr/local/bin/docker-compose
```
