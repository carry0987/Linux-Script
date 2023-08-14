## Change default network interface name on Ubuntu
If you ever interested in changing interface names to old type `ethX`, here is the tutorial for you.
As you can see in the following command, my system is having a network adapter called `ens33`.  

This is just the case of **VMware** environment, it may vary depends on the hardware but the steps to get back `ethX` will be the same.  

```log
$ ip a
1: lo: <loopback,up,lower_up> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: </loopback,up,lower_up>ens33: <broadcast,multicast,up,lower_up> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:05:a3:e2 brd ff:ff:ff:ff:ff:ff
    </broadcast,multicast,up,lower_up>inet 192.168.12.12/24 brd 192.168.12.255 scope global dynamic ens33
       valid_lft 1683sec preferred_lft 1683sec
    inet6 fe80::20c:29ff:fe05:a3e2/64 scope link
       valid_lft forever preferred_lft forever
```

From the `dmesg` command, you can see that the device got renamed during the system boot.
```log
$ dmesg | grep -i eth
[    3.050064] e1000 0000:02:01.0 eth0: (PCI:66MHz:32-bit) 00:0c:29:05:a3:e2
[    3.050074] e1000 0000:02:01.0 eth0: Intel(R) PRO/1000 Network Connection
[    3.057410] e1000 0000:02:01.0 ens33: renamed from eth0
```

To get an `ethX` back, edit the `grub` file.
```bash
sudo vim /etc/default/grub
```
Look for **`GRUB_CMDLINE_LINUX`** and add the following `net.ifnames=0 biosdevname=0`.

From:
```ini
GRUB_CMDLINE_LINUX=""
```

To:
```ini
GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"
```

Generate a new grub file using the following command.
```bash
$ sudo grub-mkconfig -o /boot/grub/grub.cfg
Generating grub configuration file ...
Warning: Setting GRUB_TIMEOUT to a non-zero value when GRUB_HIDDEN_TIMEOUT is set is no longer supported.
Found linux image: /boot/vmlinuz-4.4.0-15-generic
Found initrd image: /boot/initrd.img-4.4.0-15-generic
Found memtest86+ image: /memtest86+.elf
Found memtest86+ image: /memtest86+.bin
done
```

Reboot your system.
```bash
sudo reboot
```

After the system reboot, just check whether you have an `ethX` back.
```log
$ ip a
1: lo: <loopback,up,lower_up> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: </loopback,up,lower_up>eth0: <broadcast,multicast,up,lower_up> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:05:a3:e2 brd ff:ff:ff:ff:ff:ff
    </broadcast,multicast,up,lower_up>inet 192.168.12.12/24 brd 192.168.12.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::20c:29ff:fe05:a3e2/64 scope link
       valid_lft forever preferred_lft forever
```
