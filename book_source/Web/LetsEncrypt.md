## Let's Encrypt

### Remove (revoke) a domain in Let’s Encrypt

To remove a `Let’s Encrypt` certificate from a domain no longer served from server.    
In this example, I use the `www.mydomain.com` domain.  

I will remove it in 3 steps:  
1. Backup
2. Revoke the certificate
3. Delete all files relating to the certificate

`#` – Indicates that the command that follows must be executed with `root` permissions directly with the root user or with the sudo command.  
`$` – Indicates that the following command can be executed by a normal user without administrative privileges.

### Backup
First, make a backup
```bash
sudo cp /etc/letsencrypt/ /etc/letsencrypt.backup -r
```

### Revoke
Then `revoke` the cert
```bash
sudo certbot revoke --cert-path /etc/letsencrypt/archive/www.mydomain.com/cert1.pem
# Saving debug log to /var/log/letsencrypt/letsencrypt.log
# Starting new HTTPS connection (1): acme-v01.api.letsencrypt.org
```
### Delete the files
Finally, delete all files relating to certificate `www.mydomain.com`
```bash
sudo certbot delete
# Saving debug log to /var/log/letsencrypt/letsencrypt.log

Which certificate would you like to delete?
-------------------------------------------------------------------------------
1: www.domain1.com
2: www.domain2.com
3: www.mydomain.com
-------------------------------------------------------------------------------
Select the appropriate number [1-6] then [enter] (press 'c' to cancel): 3

-------------------------------------------------------------------------------
Deleted all files relating to certificate www.mydomain.com.
-------------------------------------------------------------------------------
```
