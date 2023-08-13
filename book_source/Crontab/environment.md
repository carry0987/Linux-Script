### Crontab Environment
`cron` invokes the command from the user's HOME directory with the shell, `/usr/bin/sh`.  
`cron` supplies a default environment for every shell, defining:
```bash
HOME=[user-home-directory]
LOGNAME=[user-login-id]
PATH=/usr/bin:/usr/sbin:.
SHELL=/usr/bin/sh
```
Users who desire to have their `.profile` executed must explicitly do so in the crontab entry or in a script called by the entry.
