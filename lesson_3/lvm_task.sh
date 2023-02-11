#!/bin/bash


################# task to create mirror volumes for var ###################
# create physical volumes, volume group and logical volume for /var
pvcreate /dev/sdc /dev/sdd && vgcreate vg_var /dev/sdc /dev/sdd && lvcreate -l 100%FREE -m1 -n lv_var vg_var
# create filesystem
mkfs.xfs /dev/vg_var/lv_var
# create dir for mounting and mount
mkdir /mnt/tmp_var && mount /dev/vg_var/lv_var /mnt/tmp_var
# transfer files to new volume
cp -aR /var/* /mnt/tmp_var && rsync -avHPSAX /var/ /mnt/tmp_var
# unmount tmp_var and mount new logical volume to /var
umount /mnt/tmp_var && mount /dev/vg_var/lv_var /var
# create fstab
echo "$(blkid | grep var: | awk '{print $2}') /var xfs defaults 0 0" >> /etc/fstab
###################### task to create volume for home ###########################
# create logical volume for /home
pvcreate /dev/sde && vgcreate vg_home /dev/sde && lvcreate -n lv_home -L 1G /dev/vg_home
# create filesystem
mkfs.ext4 /dev/vg_home/lv_home
# create folder for tmp_home and mount new volume there
mkdir /mnt/tmp_home && mount /dev/vg_home/lv_home /mnt/tmp_home
# Transfer all data to new home
cp -aR /home/* /mnt/tmp_home
# Remove home amd remount
rm -rf /home/* && umount /mnt/tmp_home && mount /dev/vg_home/lv_home /home
# Create fstab
echo "$(blkid | grep home | awk '{print $2}') /home ext4 defaults 0 0" >> /etc/fstab
######################## task for snapshots volume for home ########################
# create files in home
for i in {1..10}; do touch /home/vagrant/tmp_txt_$i.txt && echo $i >> tmp_txt_$i.txt; done
# create snapshot volume
lvcreate -L 100MB -s -n lv_home_snapshot /dev/vg_home/lv_home
# delete files and checks that files really gone
for i in {1..5}; do rm -f /home/vagrant/tmp_txt_$i.txt; done
ls -la /home/vagrant/ | grep txt
umount /home
lvconvert --merge /dev/vg_home/lv_home_snapshot
mount /home
# Test files ok
ls -la /home/vagrant/
cat /home/vagrant/tmp_txt_*.txt
