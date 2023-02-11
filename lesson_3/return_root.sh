#!/bin/bash

lvremove /dev/VolGroup00/LogVol00
lvcreate -n VolGroup00/LogVol00 -L 8G /dev/VolGroup00
mkfs.xfs /dev/VolGroup00/LogVol00
mount /dev/VolGroup00/LogVol00 /mnt
xfsdump -J - /dev/vg_root/lv_root | xfsrestore -J - /mnt
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
cat << EOF | chroot /mnt/
  grub2-mkconfig -o /boot/grub2/grub.cfg
  for i in $(ls /boot/initramfs-*img); do dracut -v $i `echo $i|sed "s/initramfs-//g;s/.img//g"` --force; done
  sed -i 's#rd.lvm.lv=vg_root/lv_root#rd.lvm.lv=VolGroup00/LogVol00#g' /boot/grub2/grub.cfg
EOF