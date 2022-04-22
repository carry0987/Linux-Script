# Enable `sudo` without password in Ubuntu/Debian
You probably know that in Ubuntu/Debian, you should not run as the **root** user, but  
should use the **`sudo`** command instead to run commands that require **root**  
privileges. However, it can also be inconvenient to have to enter your password  
every time that you use sudo. Here’s a quick fix that removes the requirement to  
enter you password for sudo.

## Step
1. Open the `/etc/sudoers` file (as **root**, of course!) by running:
```bash
sudo visudo
```
You should **never** edit `/etc/sudoers` with a regular text editor, such as `Vim` or `nano`,  
because they do not validate the syntax like the **visudo** editor.

2. At the **end** of the `/etc/sudoers` file add this line:
```
username     ALL=(ALL) NOPASSWD:ALL
```
Replace **username** with your account username, of course. Save the file and  
exit with **`<ESC>wq`**. If you have any sort of syntax problem, **visudo** will  
warn you and you can abort the change or open the file for editing again.

It is important to add this line at the **end** of the file,  
so that the other permissions do not override this directive, since they are processed in order.

3. Finally, open a new terminal window and run a command that requires root privileges,  
such as **`sudo apt update`**. You should not be prompted for your password!

That’s it! Enjoy your new freedom! 🙂

## Add user to sudoer
```bash
sudo usermod -aG sudo [username]
```
