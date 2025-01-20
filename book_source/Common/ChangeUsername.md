## Change username
In the Linux operating system, usernames are essential for identifying and managing user accounts. A username is a unique identity for a user that allows them to log in, access files, and perform certain tasks on the system. However, there may be times when you need to change your username owing to personal preferences or security concerns.

Fortunately, Linux provides various options for changing usernames, giving flexibility and simplicity to both system administrators and users.

### usermod
The `usermod` command is a powerful utility that allows system administrators to change the username and other attributes of a user account.  
You can modify a username with the `usermod` command by following a few simple steps.

1. **Check Existing Username**
Before making any changes, it is essential to verify the current username of the account you wish to modify.  
This step ensures that you have accurate information and helps avoid any confusion during the renaming process.  
To check the current username, use the following command in the terminal:
```bash
whoami
```

2. **Change the Username**
Once you have identified the account's current username, you can use the usermod command to change it.  
The usermod command allows you to modify various attributes of a user account, including the username. The syntax for the usermod command to change the username is as follows:
```bash
sudo usermod -l new_username old_username
```
Replace "new_username" with the desired new username and "old_username" with the current username of the account.  
The 'sudo' command is used to execute the usermod command with administrative privileges.

3. **Update the User's Home Directory and Group**
After changing the username, it is crucial to update the user's home directory and group to reflect the new username. This step ensures consistency and prevents any conflicts or inconsistencies in the system. To update the user's home directory and group, use the following command:
```bash
sudo usermod -d /home/new_username -m new_username
```
In this command, replace "new_username" with the newly assigned username.  
The '-d' option specifies the new home directory path and '-m' ensures the user's files are moved to the new directory.

4. **Verify the Changes**
To confirm that the username has been successfully changed, you can use the following command:
```bash
whoami
```
The terminal should display the new username associated with the current session, indicating that the changes have taken effect.
