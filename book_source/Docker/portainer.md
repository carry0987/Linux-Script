# Portainer
Install protainer via `docker-compose`

## Nginx
1. Create nginx config
```bash
sudo vim /etc/nginx/sites-available/portainer.example.com
```

2. Content of `portainer.example.com`
```nginx
server {
    listen 80;
    listen [::]:80;

    server_name portainer.example.com;

    location / {
        proxy_pass https://127.0.0.1:9443;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
    }
}
```

3. Create symbolic link
```bash
sudo ln -s /etc/nginx/sites-available/portainer.example.com /etc/nginx/sites-enabled/
```

4. Check nginx config
```bash
sudo nginx -t
```

5. Reload nginx config
```bash
sudo systemctl reload nginx
```

## Docker-compose
1. Make folder for portainer
```bash
mkdir portainer
cd portainer
```

2. **`docker-compose.yml`**
```yaml
version: '3.1'

services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: always
    security_opt:
      - no-new-privileges:true
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./portainer-data:/data
    ports:
      - 9443:9443

```
