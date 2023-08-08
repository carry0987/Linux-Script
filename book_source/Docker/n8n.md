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

6. If you want to make **`N8N`** run under same network with **`NginxProxyManager`**, you can add the following code to `docker-compose.yml`
```yml
networks:
  default:
    external: true
    name: scoobydoo
```

7. Start the container
```bash
docker compose up -d
```

## Update N8N
```bash
docker compose pull && docker compose stop && docker compose up -d
```
