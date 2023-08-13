## Docker

### Install
Follow `Docker Installation Guide` via this **[LINK](https://docs.docker.com/engine/install/ubuntu/)**

### Setup
1. Start docker-client and set automatically start on boot
```bash
sudo systemctl start docker && sudo systemctl enable docker
```

### Run Docker Without Sudo
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

### Docker-compose
1. Download the corresponding Linux version of Docker-compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-$(uname -s)-$(uname -m)" \
          -o /usr/local/bin/docker-compose
```

2. Give execute permission
```bash
sudo chmod +x /usr/local/bin/docker-compose
```
