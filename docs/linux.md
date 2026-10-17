#!/bin/sh


dd if=/dev/zero of=rootfs.img bs=4096 count=1024
#mke2fs rootfs.img
mkfs.ext3 rootfs.img
mkdir rootfs
sudo mount -o loop rootfs.img rootfs/

sudo mkdir rootfs/dev
sudo mknod rootfs/dev/ram b 1 0
sudo mknod rootfs/dev/console c 5 1

# config other executable file
grub-install --root-directory=rootfs/  /dev/sda

sudo umount rootfs

# simple way to run ISO
qemu-system-x86_64 -hda ubuntu.img -boot d -cdrom /home/sk/Soft_Backup/OS\ Images/New/ubuntu-15.04-server-amd64.iso -m 640
