#!/usr/bin/bash

# Create pv, vg, lv for root
pvcreate /dev/sdb && vgcreate vg_root /dev/sdb && lvcreate -n lv_root -l +100%FREE /dev/vg_root
# make fs and mount
mkfs.xfs /dev/vg_root/lv_root && mount /dev/vg_root/lv_root /mnt
# Transfer data from root
xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt
# Imitate real root
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
# chrot
cat << EOF | chroot /mnt/
  grub2-mkconfig -o /boot/grub2/grub.cfg
  for i in $(ls /boot/initramfs-*img); do dracut -v $i `echo $i|sed "s/initramfs-//g;s/.img//g"` --force; done
  sed -i 's#rd.lvm.lv=VolGroup00/LogVol00#rd.lvm.lv=vg_root/lv_root#g' /boot/grub2/grub.cfg
EOF
