## TFTP

### Start TFTP server
Activate the tftp server on your Mac:
To change the properties, edit the file
```
/System/Library/LaunchDaemons/tftp.plist
```

The default directory is `/private/tftpboot`.

Make this directory accessible for everybody.
```
sudo chmod 777 /private/tftpboot
sudo launchctl start com.apple.tftpd
```

And start it with
```
sudo launchctl load -F /System/Library/LaunchDaemons/tftp.plist
```

### Stop TFTP server
If you want to stop the daemon, do
```
sudo launchctl unload /System/Library/LaunchDaemons/tftp.plist
sudo launchctl stop com.apple.tftpd
```

Change back the permissions of the directory to `/private/tftpboot`
```
sudo chmod 755 /private/tftpboot
```
