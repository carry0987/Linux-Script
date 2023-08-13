## Nginx

### Installation
```bash
sudo apt install nginx
```

If you have the `ufw` firewall running, you will need to allow connections to Nginx. You should enable the most restrictive profile that will still allow the traffic you want. Since you haven’t configured SSL for your server yet, for now you only need to allow HTTP traffic on port `80`.

You can enable this by typing:
```bash
sudo ufw allow 'Nginx HTTP'
```

You can verify the change by typing:
```bash
sudo ufw status
```

You should see HTTP traffic allowed in the displayed output:
```log
Output
Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere
Nginx HTTP                 ALLOW       Anywhere
OpenSSH (v6)               ALLOW       Anywhere (v6)
Nginx HTTP (v6)            ALLOW       Anywhere (v6)
```

### Add a new site with **`PHP`** support
1. Create a new directory for the site
```bash
sudo mkdir /var/www/example.com
```

2. Change the owner of the directory to the current user
```bash
sudo chown -R $USER:$USER /var/www/example.com
```

3. Create a new configuration file for the site
```bash
sudo vim /etc/nginx/sites-available/example.com
```
Add the following content to the file
```nginx
server {
    listen 80;
    listen [::]:80;

    #Increase file upload maximum size
    client_max_body_size 256M;

    # Site root directory
    root /var/www/example.com;
    index index.php index.html index.htm;

    # Domain name
    server_name example.com www.example.com;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
    }
}
```

4. Create a symbolic link to the configuration file
```bash
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
```

5. Test the configuration file
```bash
sudo nginx -t
```

6. Reload the `Nginx` service
```bash
sudo systemctl reload nginx
```

7. If you want to maintain the directory of the site easily, you can create a symbolic link to the directory
```bash
sudo ln -s /var/www/example.com /home/$USER/example.com
```

#### Allowing HTTPS Through the Firewall
If you have the `ufw` firewall enabled, as recommended by the prerequisite guides, you’ll need to adjust the settings to allow for HTTPS traffic. Luckily, Nginx registers a few profiles with `ufw` upon installation.

You can see the current setting by typing:
```bash
sudo ufw status
```

It will probably look like this, meaning that only HTTP traffic is allowed to the web server:
```log
Output
Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere                  
Nginx HTTP                 ALLOW       Anywhere                  
OpenSSH (v6)               ALLOW       Anywhere (v6)             
Nginx HTTP (v6)            ALLOW       Anywhere (v6)
```

To additionally let in HTTPS traffic, allow the Nginx Full profile and delete the redundant Nginx HTTP profile allowance:
```bash
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
```

Your status should now look like this:
```bash
sudo ufw status
```

```log
Output
Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere
Nginx Full                 ALLOW       Anywhere
OpenSSH (v6)               ALLOW       Anywhere (v6)
Nginx Full (v6)            ALLOW       Anywhere (v6)
```

#### Set `LetsEncrypt`:
1. Install `certbot`
```bash
sudo apt install certbot python3-certbot-nginx
```

2. Obtaining an SSL Certificate
```bash
sudo certbot --nginx -d example.com -d www.example.com
```

3. Verifying Certbot Auto-Renewal
Let’s Encrypt’s certificates are only valid for ninety days. This is to encourage users to automate their certificate renewal process. The `certbot` package we installed takes care of this for us by adding a systemd timer that will run twice a day and automatically renew any certificate that’s within thirty days of expiration.

You can query the status of the timer with `systemctl`:
```bash
sudo systemctl status certbot.timer
```

To test the renewal process, you can do a dry run with `certbot`:
```bash
sudo certbot renew --dry-run
```
If you see no errors, you’re all set. When necessary, Certbot will renew your certificates and reload Nginx to pick up the changes. If the automated renewal process ever fails, Let’s Encrypt will send a message to the email you specified, warning you when your certificate is about to expire.

### Nginx Reverse Proxy with Cloudflare
#### Normal Secure
```nginx
server {
    listen 80;
    listen [::]:80;

    root /var/www/example.com;
    index index.php index.html index.htm;

    server_name example.com;

    location / {
        proxy_pass http://127.0.0.1:8010;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
    }
}
```

#### Full(Strict) Secure
```nginx
server {
    listen 80;
    listen [::]:80;
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    #root /var/www/example.com;
    #index index.php index.html index.htm;

    server_name example.com;

    ssl_certificate /etc/ssl/certs/cf_example.com.pem;
    ssl_certificate_key /etc/ssl/private/cf_example.com-key.pem;
    ssl_client_certificate /etc/ssl/certs/origin-pull-ca.pem;
    ssl_verify_client on;

    location / {
        proxy_pass http://127.0.0.1:8010;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
    }
}
```

### CDN
```nginx
server {
    listen 80;
    server_name cdn.domain.org;
    root /usr/share/nginx/cdn;

    location / {
        proxy_pass http://domain.org;
        proxy_set_header Host $http_host;
        proxy_set_header  True-Client-IP  $remote_addr;
    }

    location ~* \.(jpg|png|gif|jpeg|webp|css|mp3|wav|swf|mov|doc|pdf|xls|ppt|docx|pptx|xlsx)$ {
        expires max;
        proxy_set_header  X-Real-IP  $remote_addr;
        proxy_pass http://domain.org;
        proxy_ignore_headers X-Accel-Expires Expires Cache-Control;
        proxy_store /usr/share/nginx/cdn$uri;
        proxy_store_access user:rw group:rw all:r;
        proxy_read_timeout 60s;
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
    }

    location ~ /\.ht {
        deny all;
    }

    location ~ ~\$ {
        deny all;
    }

    # An appropriate PHP handler should be set up here
    # location ~ \.php$ { deny all; }
}
```
