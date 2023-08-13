## Crontab
Setting up `cron` jobs in Unix, Solaris & Linux

### Quick Reference
`cron` is a Unix, solaris, Linux utility that allows tasks to be automatically run in the background at regular intervals by the `cron` daemon. 

**`cron` meaning** – There is no definitive explanation but most accepted answers is reportedly from Ken Thompson ( author of unix `cron` ), name `cron` comes from chron ,the Greek prefix for `time`

**What is `cron` ?** – `Cron` is a daemon which runs at the times of system boot from /etc/init.d scripts. If needed it can be stopped/started/restart using init script or with command service crond start in Linux systems.

This document covers following aspects of Unix, Linux `cron` jobs to help you understand and implement cronjobs successfully
