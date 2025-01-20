## UFW

### Enable UFW
Before enabling UFW, ensure that OpenSSH is allowed to prevent being locked out of your server:
```bash
sudo ufw allow OpenSSH
```

Now you can safely enable UFW:
```bash
sudo ufw enable
```

### Check UFW Status
```bash
sudo ufw status
```

### Set Default Policies
Set the default policies to deny incoming and allow outgoing traffic:
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

### Allow Specific Services or Ports
Allow HTTP and HTTPS:
```bash
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
```

Allow a specific port, such as SSH:
```bash
sudo ufw allow 22
```

Allow a specific IP to connect to a certain port:
```bash
sudo ufw allow from 192.168.1.0/24 to any port 3306
```

### Deny Specific Ports
Directly deny a specific port:
```bash
sudo ufw deny 23
```

### Delete Rules
Remove a rule that allows a particular service, such as 'Nginx HTTP':
```bash
sudo ufw delete allow 'Nginx HTTP'
```

### Reset UFW
Reset UFW to the default state; all rules will be deleted:
```bash
sudo ufw reset
```

### Additional Commands for Specific Scenarios
1. **Set Named Services**: Some services register with UFW, such as 'Nginx Full', which can be used to allow both HTTP and HTTPS.
   ```bash
   sudo ufw allow 'Nginx Full'
   ```

2. **Check Status with Details**: Verify the final status to ensure the settings are correct.
   ```bash
   sudo ufw status verbose
   ```

3. **Logging**: Enable logging to monitor security issues.
   ```bash
   sudo ufw logging on
   ```

These commands will help effectively manage your server's UFW firewall rules, ensuring security and proper service operation.
