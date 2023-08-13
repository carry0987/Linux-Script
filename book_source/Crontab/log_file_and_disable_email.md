### Disable Email
By default, cron jobs send an email to the user account executing the cronjob. This can inundate your inbox with messages regarding your cronjobs. If this is not desired, you can disable these emails.

To suppress the email alerts, append the following command at the end of the cron job line.
```
>/dev/null 2>&1
```

This command redirects both standard output (file descriptor 1) and standard error (file descriptor 2) to `/dev/null`, which is a special file that discards all data written to it (but reports that the write operation succeeded). In simple words, this operation is discarding both the regular output and error messages, hence, no email is sent.

### Generate log file
To collect the cron execution execution log in a file:
```
30 18 * * * rm /home/someuser/tmp/* > /home/someuser/cronlogs/clean_tmp_dir.log
```
