### Crontab Commands
To specify a editor to open crontab file, use: `export EDITOR=vi ;`
Below is a list of crontab commands:

| Command | Description |
| --- | :--- |
| `crontab -e` | Edit crontab file, or create one if it doesn’t already exist. |
| `crontab -l` | Display crontab list of cron jobs, display crontab file contents. |
| `crontab -r` | Remove your crontab file. |
| `crontab -v` | Display the last time you edited your crontab file. (This option is only available on a few systems.) |

### Service Commands
Below is a list of `crontab` service commands:

| Command | Description |
| --- | :--- |
| `sudo service cron status` | Check the status of cron service. |
| `sudo service cron start` | Start the cron service. |
| `sudo service cron stop` | Stop the cron service. |
| `sudo service cron reload` | Reload the cron service configuration. |
| `sudo service cron restart` | Restart the cron service. |
