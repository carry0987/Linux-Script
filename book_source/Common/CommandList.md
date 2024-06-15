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

### Make `zstdmt` as `zstd`
`zstdmt` is faster than `zstd`, since it uses multi-threading.
```bash
sudo ln -s /usr/bin/zstdmt /usr/bin/zstd
```

## Add user & group
```bash
sudo adduser [username]
```
> P.S. Don't use `useradd` to add user, it will not create home directory for user.

## Add user to sudo group
```bash
sudo usermod -aG sudo [username]
```

Change user password
```bash
sudo passwd [username]
```

## Change default editor to `vim`
```bash
sudo update-alternatives --config editor
```

And then choose `vim.basic`:
```bash
There are 3 choices for the alternative editor (providing /usr/bin/editor).

  Selection    Path                Priority   Status
------------------------------------------------------------
* 0            /bin/nano            40        auto mode
  1            /bin/nano            40        manual mode
  2            /usr/bin/vim.basic   30        manual mode
  3            /usr/bin/vim.tiny    15        manual mode

Press <enter> to keep the current choice[*], or type selection number: 2
update-alternatives: using /usr/bin/vim.basic to provide /usr/bin/editor (editor) in manual mode
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

## Clear history
```bash
history -c
```

If in MacOS, and you're using `zsh` as default shell, use
```bash
history -p
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
