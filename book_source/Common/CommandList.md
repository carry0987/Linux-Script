# Linux Command List

## Count folder's size
```bash
du -sch /path/to/folder/*type
```

## Set Time & Date NTP
```bash
sudo timedatectl set-ntp yes
```

## Set default shell
```bash
sudo ln -fs /bin/bash /bin/sh
```

## Use tee instead of echo to add lines into file
The redirection is done by the shell before sudo is even started.  
So either make sure the redirection happens in a shell with the right permissions  
```bash
sudo bash -c 'echo "hello" > f.txt'
```
Or use tee  
```bash
echo "hello" | sudo tee f.txt  # add -a for append (>>)
```

## Scan WiFi
```bash
sudo iwlist wlan0 scan
```

## Search Depend packages of Application
### Way 1
```bash
apt-cache depends build-essential
```

### Way 2
```bash
apt-cache showpkg build-essential
```

## APT Error Fix
If it shows
```
E: Encountered a section with no Package: header
```
Just clean the error link
```bash
sudo rm /var/lib/apt/lists/* -vf
```
And then
```bash
sudo apt-get update
```

## Start SSH
```bash
sudo /etc/init.d/ssh start
```

## Change SSH Port
```bash
sudo vim /etc/ssh/sshd_config
```
then
```bash
sudo service ssh restart
```

## Regenerate SSH Key
```bash
ssh-keygen -R "you server hostname or ip"
```

## Set default path of terminal
```bash
echo 'cd ~/Desktop/' >> ~/.bashrc
```

If in MacOS, use
```bash
echo 'cd ~/Desktop/' >> ~/.zprofile
```

## Zip
**zip**
- `-h Show the help interface`
- `-m After the file is compressed, delete the original file`
- `-o Set the latest change time of all files in the archive to the time of compression`
- `-q Quiet mode, does not display the execution of instructions during compression`
- `-r Treats all subdirectories under the specified directory together with the file`
- `-P Set the compression password`

## Unzip
**unzip**
- `-l Show the files whitch contained in the compressed file`
- `-t Check if the compressed file is correct`
- `-P<password> Unzip files with password`

## Terminal
- **Ctrl + Alt + F2 = Terminal**
- **Alt + F7 = Exit Terminal**

## Rclone
Show process every 1 second when upload files:
```bash
rclone copy -v --stats 1s [File] [Target]
```

Remove rclone:
```bash
sudo rm /usr/bin/rclone
```
```bash
sudo rm /usr/local/share/man/man1/rclone.1
```

Rclone Config File
```bash
rclone -h | grep "Config file"
```

## Screen
Kill specific screen
```bash
screen -S [pid/name] -X quit
```
Or
```bash
kill [pid]
```

Kill all screen
```bash
killall screen
```
