# N8N

## Setup
1. Create folder for n8n
```bash
mkdir n8n && cd n8n
```

2. Create `.env` file and set the following variables
```ini
  # Database
  POSTGRES_USER=admin
  POSTGRES_PASSWORD=changeme
  POSTGRES_DB=n8n

  POSTGRES_NON_ROOT_USER=n8n
  POSTGRES_NON_ROOT_PASSWORD=changeme

  # Configure
  EXECUTIONS_DATA_PRUNE=true
  EXECUTIONS_DATA_MAX_AGE=168
  GENERIC_TIMEZONE=Asia/Taipei
  WEBHOOK_URL=https://n8n.example.com
  N8N_HOST=n8n.example.com
  N8N_PROTOCOL=https
  N8N_EMAIL_MODE=smtp
  N8N_SMTP_HOST=smtp.gmail.com
  N8N_SMTP_PORT=465
  N8N_SMTP_USER=example@gmail.com
  N8N_SMTP_PASS=PASSWORD
  N8N_SMTP_SENDER=example@gmail.com
  # N8N_HOST=${SUBDOMAIN}.${DOMAIN_NAME}
```

3. Create `init-data.sh` file
```bash
  #!/bin/bash
  set -e;

  if [ -n "${POSTGRES_NON_ROOT_USER:-}" ] && [ -n "${POSTGRES_NON_ROOT_PASSWORD:-}" ]; then
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
      CREATE USER ${POSTGRES_NON_ROOT_USER} WITH PASSWORD '${POSTGRES_NON_ROOT_PASSWORD}';
      GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_NON_ROOT_USER};
    EOSQL
  else
    echo "SETUP INFO: No Environment variables given!"
  fi
```

4. Make `init-data.sh` executable
```bash
sudo chmod +x init-data.sh
```

5. Create `docker-compose.yml` file
```yml
  version: '3.8'

  services:
    postgres:
      image: postgres:11-alpine
      restart: always
      environment:
        - POSTGRES_USER
        - POSTGRES_PASSWORD
        - POSTGRES_DB
        - POSTGRES_NON_ROOT_USER
        - POSTGRES_NON_ROOT_PASSWORD
      volumes:
        - ./n8n-db:/var/lib/postgresql/data
        - ./init-data.sh:/docker-entrypoint-initdb.d/init-data.sh
      healthcheck: 
        test: ['CMD-SHELL', 'pg_isready -h localhost -U ${POSTGRES_USER} -d ${POSTGRES_DB}']
        interval: 5s
        timeout: 5s
        retries: 10

    n8n:
      image: n8nio/n8n:latest
      restart: unless-stopped
      environment:
        - DB_TYPE=postgresdb
        - DB_POSTGRESDB_HOST=postgres
        - DB_POSTGRESDB_PORT=5432
        - DB_POSTGRESDB_DATABASE=${POSTGRES_DB}
        - DB_POSTGRESDB_USER=${POSTGRES_NON_ROOT_USER}
        - DB_POSTGRESDB_PASSWORD=${POSTGRES_NON_ROOT_PASSWORD}
        - EXECUTIONS_DATA_PRUNE=${EXECUTIONS_DATA_PRUNE}
        - EXECUTIONS_DATA_MAX_AGE=${EXECUTIONS_DATA_MAX_AGE}
        - GENERIC_TIMEZONE=${GENERIC_TIMEZONE}
        - WEBHOOK_URL=${WEBHOOK_URL}
        - N8N_HOST=${N8N_HOST}
        - N8N_PROTOCOL=${N8N_PROTOCOL}
        - N8N_EMAIL_MODE=${N8N_EMAIL_MODE}
        - N8N_SMTP_HOST=${N8N_SMTP_HOST}
        - N8N_SMTP_PORT=${N8N_SMTP_PORT}
        - N8N_SMTP_USER=${N8N_SMTP_USER}
        - N8N_SMTP_PASS=${N8N_SMTP_PASS}
        - N8N_SMTP_SENDER=${N8N_SMTP_SENDER}
      expose:
        - 5678
      volumes:
        - ./n8n-data:/home/node/.n8n
      depends_on:
        postgres:
          condition: service_healthy
```

6. If you want to make **`N8N`** run under same network with **`NginxProxyManager`**, you can use the following code to `docker-compose.yml`
```yml
version: '3.8'

services:
  postgres:
    image: postgres:11-alpine
    restart: always
    environment:
      - POSTGRES_USER
      - POSTGRES_PASSWORD
      - POSTGRES_DB
      - POSTGRES_NON_ROOT_USER
      - POSTGRES_NON_ROOT_PASSWORD
    volumes:
      - ./n8n-db:/var/lib/postgresql/data
      - ./init-data.sh:/docker-entrypoint-initdb.d/init-data.sh
    healthcheck: 
      test: ['CMD-SHELL', 'pg_isready -h localhost -U ${POSTGRES_USER} -d ${POSTGRES_DB}']
      interval: 5s
      timeout: 5s
      retries: 10
    networks:
      - app-tier

  n8n:
    image: n8nio/n8n:latest
    restart: unless-stopped
    environment:
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB}
      - DB_POSTGRESDB_USER=${POSTGRES_NON_ROOT_USER}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_NON_ROOT_PASSWORD}
      - EXECUTIONS_DATA_PRUNE=${EXECUTIONS_DATA_PRUNE}
      - EXECUTIONS_DATA_MAX_AGE=${EXECUTIONS_DATA_MAX_AGE}
      - GENERIC_TIMEZONE=${GENERIC_TIMEZONE}
      - WEBHOOK_URL=${WEBHOOK_URL}
      - N8N_HOST=${N8N_HOST}
      - N8N_PROTOCOL=${N8N_PROTOCOL}
      - N8N_EMAIL_MODE=${N8N_EMAIL_MODE}
      - N8N_SMTP_HOST=${N8N_SMTP_HOST}
      - N8N_SMTP_PORT=${N8N_SMTP_PORT}
      - N8N_SMTP_USER=${N8N_SMTP_USER}
      - N8N_SMTP_PASS=${N8N_SMTP_PASS}
      - N8N_SMTP_SENDER=${N8N_SMTP_SENDER}
    expose:
      - 5678
    volumes:
      - ./n8n-data:/home/node/.n8n
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - app-tier
      - scoobydoo

networks:
  app-tier:
    driver: bridge
  scoobydoo:
    external: true
```

7. Start the container
```bash
docker compose up -d
```

## Update N8N
```bash
docker compose pull && docker compose stop && docker compose up -d
```

## Reverse Proxy for N8N
1. Create `n8n.conf` file
```bash
sudo vim /etc/nginx/sites-available/n8n.conf
```

2. Add the following code to `n8n.conf`
```nginx
server {
    listen 80;
    listen [::]:80;
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name n8n.example.com;
    client_max_body_size 256M;

    # SSL with Cloudflare
    ssl_certificate /etc/ssl/certs/cf_example.com.pem;
    ssl_certificate_key /etc/ssl/private/cf_key_example.com.pem;
    ssl_client_certificate /etc/ssl/certs/origin-pull-ca.pem;
    ssl_verify_client on;

    location / {
        proxy_pass http://127.0.0.1:5678;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Frame-Options SAMEORIGIN;
        proxy_buffers 256 16k;
        proxy_buffer_size 16k;
        client_max_body_size 50m;
        client_body_buffer_size 1m;
        proxy_read_timeout 600s;
        proxy_buffering off;
        proxy_cache off;
    }

    location ~ ^/(webhook|webhook-test) {
        proxy_set_header Connection '';
        chunked_transfer_encoding off;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Frame-Options SAMEORIGIN;
        proxy_buffering off;
        proxy_cache off;
        proxy_pass http://127.0.0.1:5678;
    }
}
```

3. Create symbolic link
```bash
sudo ln -s /etc/nginx/sites-available/n8n.conf /etc/nginx/sites-enabled/n8n.conf
```

4. Test nginx configuration
```bash
sudo nginx -t
```

5. Restart nginx
```bash
sudo systemctl reload nginx
```

## Backup & Restore
### Docker
```bash
docker exec -it -u node {CONTAINER_ID} sh
```

### Backup
Backup `workflow`
```bash
n8n export:workflow --all --output=.n8n/workflow.json
```

Backup `credential`
```bash
n8n export:credentials --all --decrypted --output=.n8n/credential.json
```

### Restore
Import `workflow`
```bash
n8n import:workflow --input=.n8n/workflow.json
```

Import `credential`
```bash
n8n import:credentials --input=.n8n/credential.json
```
