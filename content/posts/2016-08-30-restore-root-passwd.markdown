---
layout: post
title:  "restore root password"
date:   2016-08-30
tags:
- root
- passwd
- lvm
- linux
---
# restoring root password #

I often find stashed virtual machine images containing useful things I could reuse; but, I can no longer find user credentials to log into these machines.

Here are two quick ways to restore access to such machines.

Please note the following solutions will prompt for password for encrypted drives e.g. [LUKS](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup).

Any solution given below can also be applied to a physical linux box, as long as we have a physical access to the machine.

## grub2 ##

Hit `e` in the grub menu to edit the configuration before booting.

Find kernel parameters (the line containing parameters start with `linux`) and append two new:

```
linux(16|efi) ... kernel parameters ... rw init=/bin/bash
```

boot the kernel by pressing `Ctrl-X`.

You should get a root shell just after kernel startup. Use `passwd` to change the password.

## mounting volume and fs ##

Boot the machine with a portable linux image (preferably a linux distribution installation image).
Go to the shell:

1. find volume groups
2. activate the volume group
3. mount the logical volume
4. change password
5. unmount

If you are not using lvm, you can skip the first 2 steps, and mount the disk (block device, e.g. `/dev/sda1`) directly in step 3 instead of volume group.

Use following commands:

```bash
# this yields volume groups names, e.g. \"fedora\"
vgscan
# this activates volume group \"fedora\"
vgchange -a y fedora
# you may need to list logical volumes
lvdisplay
# after activating a volume group you should be able to mount it, e.g. under /mnt/tmp
mkdir /mnt/tmp
mount /dev/fedora/root /mnt/tmp
# use passwd telling it to use specified root
passwd -R /mnt/tmp username
# or chroot to the root and than use passwd (this will use the passwd binary found under /mnt/tmp)
chroot /mnt/tmp passwd username
# you may also choose to manually remove the password from shadows file (2nd column)
vi /mnt/tmp/etc/shadows
# unmount fs
umount /mnt/tmp
# sync
sync
```
