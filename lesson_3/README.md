# LESSON 2 RAID

### Task
* Reduce root volume to 8G
* Create volume for `/home`
* Create volume for `/var` in mirror state
* Create snapshot volume for `/home`
  - create files in `/home`
  - take snapshot
  - delete some files
  - restore snapshot

### Result
Changed original Vagrantfile.<br>

Code for creating volumes for /var and /home, as well as for creating and deleting files and snapshots added to shell script <br>
`lvm_task.sh`. You can see all commands here. <br>
Unfortunately, I was not able to run the chroot command adequately through provision,<br>
so the commands and results for the last task are attached below as well as the screenshot. <br>

#### This is result of executing `lvm_task.sh` script <br>

```bash
[root@lvm tmp]# ./task_lvm.sh 
  Physical volume "/dev/sdc" successfully created.
  Physical volume "/dev/sdd" successfully created.
  Volume group "vg_var" successfully created
  Logical volume "lv_var" created.
meta-data=/dev/vg_var/lv_var     isize=512    agcount=4, agsize=65024 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=260096, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=855, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
sending incremental file list
./
.updated
            163 100%    0.00kB/s    0:00:00 (xfr#1, ir-chk=1024/1026)
lib/nfs/rpc_pipefs/gssd/clntXX/info
              0 100%    0.00kB/s    0:00:00 (xfr#2, ir-chk=1007/1132)

sent 164,771 bytes  received 606 bytes  330,754.00 bytes/sec
total size is 226,726,272  speedup is 1,370.97
  Physical volume "/dev/sde" successfully created.
  Volume group "vg_home" successfully created
  Logical volume "lv_home" created.
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
65536 inodes, 262144 blocks
13107 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=268435456
8 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

  Logical volume "lv_home_snapshot" created.
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_10.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_6.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_7.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_8.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_9.txt
  Merging of volume vg_home/lv_home_snapshot started.
  vg_home/lv_home: Merged: 100.00%
total 24
drwx------. 3 vagrant vagrant 4096 Feb 11 21:01 .
drwxr-xr-x. 4 root    root    4096 Feb 11 21:01 ..
-rw-r--r--. 1 vagrant vagrant   18 Apr 11  2018 .bash_logout
-rw-r--r--. 1 vagrant vagrant  193 Apr 11  2018 .bash_profile
-rw-r--r--. 1 vagrant vagrant  231 Apr 11  2018 .bashrc
drwx------. 2 vagrant vagrant 4096 Feb 11 20:59 .ssh
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_10.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_1.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_2.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_3.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_4.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_5.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_6.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_7.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_8.txt
-rw-r--r--. 1 root    root       0 Feb 11 21:01 tmp_txt_9.txt
```
<br>

#### This is result of executing `reduce_root.sh` script <br>

```bash
[root@lvm tmp]# ./reduce_root.sh 
  Physical volume "/dev/sdb" successfully created.
  Volume group "vg_root" successfully created
  Logical volume "lv_root" created.
meta-data=/dev/vg_root/lv_root   isize=512    agcount=4, agsize=655104 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=2620416, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.7 (dump format 3.0)
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.7 (dump format 3.0)
xfsdump: level 0 dump of lvm:/
xfsdump: dump date: Sat Feb 11 21:19:24 2023
xfsdump: session id: de504580-51b4-4957-8d10-2cd05635e0f8
xfsdump: session label: ""
xfsrestore: searching media for dump
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 850445184 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsrestore: examining media file 0
xfsrestore: dump description: 
xfsrestore: hostname: lvm
xfsrestore: mount point: /
xfsrestore: volume: /dev/mapper/VolGroup00-LogVol00
xfsrestore: session time: Sat Feb 11 21:19:24 2023
xfsrestore: level: 0
xfsrestore: session label: ""
xfsrestore: media label: ""
xfsrestore: file system id: b60e9498-0baa-4d9f-90aa-069048217fee
xfsrestore: session id: de504580-51b4-4957-8d10-2cd05635e0f8
xfsrestore: media id: ccc36d97-27d2-4ca0-84be-7d3796414c0d
xfsrestore: searching media for directory dump
xfsrestore: reading directories
xfsdump: dumping non-directory files
xfsrestore: 2698 directories and 23618 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsdump: ending media file
xfsdump: media file size 827221112 bytes
xfsdump: dump size (non-dir files) : 814058328 bytes
xfsdump: dump complete: 6 seconds elapsed
xfsdump: Dump Status: SUCCESS
xfsrestore: restore complete: 6 seconds elapsed
xfsrestore: Restore Status: SUCCESS
[root@lvm /]#   grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-862.2.3.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img
done
[root@lvm /]#   for i in /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img; do dracut -v /boot/ /boot/ --force; done
Kernel version /boot/ has no module directory /lib/modules//boot/
Executing: /sbin/dracut -v /boot/ /boot/ --force
dracut module 'busybox' will not be installed, because command 'busybox' could not be found!
dracut module 'crypt' will not be installed, because command 'cryptsetup' could not be found!
dracut module 'dmraid' will not be installed, because command 'dmraid' could not be found!
dracut module 'dmsquash-live-ntfs' will not be installed, because command 'ntfs-3g' could not be found!
dracut module 'multipath' will not be installed, because command 'multipath' could not be found!
dracut module 'busybox' will not be installed, because command 'busybox' could not be found!
dracut module 'crypt' will not be installed, because command 'cryptsetup' could not be found!
dracut module 'dmraid' will not be installed, because command 'dmraid' could not be found!
dracut module 'dmsquash-live-ntfs' will not be installed, because command 'ntfs-3g' could not be found!
dracut module 'multipath' will not be installed, because command 'multipath' could not be found!
*** Including module: bash ***
*** Including module: nss-softokn ***
*** Including module: i18n ***
*** Including module: drm ***
*** Including module: plymouth ***
*** Including module: dm ***
Skipping udev rule: 64-device-mapper.rules
Skipping udev rule: 60-persistent-storage-dm.rules
Skipping udev rule: 55-dm.rules
*** Including module: kernel-modules ***
*** Including module: lvm ***
Skipping udev rule: 64-device-mapper.rules
Skipping udev rule: 56-lvm.rules
Skipping udev rule: 60-persistent-storage-lvm.rules
*** Including module: qemu ***
*** Including module: resume ***
*** Including module: rootfs-block ***
*** Including module: terminfo ***
*** Including module: udev-rules ***
Skipping udev rule: 40-redhat-cpu-hotplug.rules
Skipping udev rule: 91-permissions.rules
*** Including module: biosdevname ***
*** Including module: systemd ***
*** Including module: usrmount ***
*** Including module: base ***
*** Including module: fs-lib ***
*** Including module: shutdown ***
*** Including modules done ***
Failed to install module hv_netvsc

Broadcast message from systemd-journald@lvm (Sat 2023-02-11 21:19:33 UTC):

dracut[4593]: Failed to install module hv_netvsc

*** Installing kernel module dependencies and firmware ***

Message from syslogd@localhost at Feb 11 21:19:33 ...
 dracut:Failed to install module hv_netvsc
*** Installing kernel module dependencies and firmware done ***
*** Resolving executable dependencies ***
*** Resolving executable dependencies done***
*** Hardlinking files ***
*** Hardlinking files done ***
*** Stripping files ***
*** Stripping files done ***
*** Generating early-microcode cpio image contents ***
*** No early-microcode cpio image needed ***
*** Store current command line parameters ***
rm: cannot remove '/boot': Is a directory
*** Creating image file ***
*** Creating image file done ***
*** Creating initramfs image file '/boot' done ***
[root@lvm /]#   sed -i 's#rd.lvm.lv=VolGroup00/LogVol00#rd.lvm.lv=vg_root/lv_root#g' /boot/grub2/grub.cfg
[root@lvm /]# exit
[root@lvm tmp]# reboot -h now
PolicyKit daemon disconnected from the bus.
We are no longer a registered authentication agent.
```

#### This is result of executing `return_root.sh` script <br>

```bash
[root@lvm tmp]# ./return_root.sh 
Do you really want to remove active logical volume VolGroup00/LogVol00? [y/n]: y
  Logical volume "LogVol00" successfully removed
WARNING: xfs signature detected on /dev/VolGroup00/LogVol00 at offset 0. Wipe it? [y/n]: y
  Wiping xfs signature on /dev/VolGroup00/LogVol00.
  Logical volume "LogVol00" created.
meta-data=/dev/VolGroup00/LogVol00 isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.7 (dump format 3.0)
xfsdump: level 0 dump of lvm:/
xfsdump: dump date: Sat Feb 11 21:27:52 2023
xfsdump: session id: 47f34ec8-3fce-4658-9b94-a2e28ea0a3af
xfsdump: session label: ""
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.7 (dump format 3.0)
xfsrestore: searching media for dump
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 849231552 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsrestore: examining media file 0
xfsrestore: dump description: 
xfsrestore: hostname: lvm
xfsrestore: mount point: /
xfsrestore: volume: /dev/mapper/vg_root-lv_root
xfsrestore: session time: Sat Feb 11 21:27:52 2023
xfsrestore: level: 0
xfsrestore: session label: ""
xfsrestore: media label: ""
xfsrestore: file system id: da246749-63e7-45ba-9658-7df412fc75d8
xfsrestore: session id: 47f34ec8-3fce-4658-9b94-a2e28ea0a3af
xfsrestore: media id: f4745bad-f341-4e69-8870-fb1b4b984759
xfsrestore: searching media for directory dump
xfsrestore: reading directories
xfsdump: dumping non-directory files
xfsrestore: 2706 directories and 23627 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsdump: ending media file
xfsdump: media file size 825909904 bytes
xfsdump: dump size (non-dir files) : 812740744 bytes
xfsdump: dump complete: 5 seconds elapsed
xfsdump: Dump Status: SUCCESS
xfsrestore: restore complete: 5 seconds elapsed
xfsrestore: Restore Status: SUCCESS
[root@lvm /]#   grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-862.2.3.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img
done
[root@lvm /]#   for i in /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img; do dracut -v /boot/ /boot/ --force; done
Kernel version /boot/ has no module directory /lib/modules//boot/
Executing: /sbin/dracut -v /boot/ /boot/ --force
dracut module 'busybox' will not be installed, because command 'busybox' could not be found!
dracut module 'crypt' will not be installed, because command 'cryptsetup' could not be found!
dracut module 'dmraid' will not be installed, because command 'dmraid' could not be found!
dracut module 'dmsquash-live-ntfs' will not be installed, because command 'ntfs-3g' could not be found!
dracut module 'multipath' will not be installed, because command 'multipath' could not be found!
dracut module 'busybox' will not be installed, because command 'busybox' could not be found!
dracut module 'crypt' will not be installed, because command 'cryptsetup' could not be found!
dracut module 'dmraid' will not be installed, because command 'dmraid' could not be found!
dracut module 'dmsquash-live-ntfs' will not be installed, because command 'ntfs-3g' could not be found!
dracut module 'multipath' will not be installed, because command 'multipath' could not be found!
*** Including module: bash ***
*** Including module: nss-softokn ***
*** Including module: i18n ***
*** Including module: drm ***
*** Including module: plymouth ***
*** Including module: dm ***
Skipping udev rule: 64-device-mapper.rules
Skipping udev rule: 60-persistent-storage-dm.rules
Skipping udev rule: 55-dm.rules
*** Including module: kernel-modules ***
*** Including module: lvm ***
Skipping udev rule: 64-device-mapper.rules
Skipping udev rule: 56-lvm.rules
Skipping udev rule: 60-persistent-storage-lvm.rules
*** Including module: qemu ***
*** Including module: resume ***
*** Including module: rootfs-block ***
*** Including module: terminfo ***
*** Including module: udev-rules ***
Skipping udev rule: 40-redhat-cpu-hotplug.rules
Skipping udev rule: 91-permissions.rules
*** Including module: biosdevname ***
*** Including module: systemd ***
*** Including module: usrmount ***
*** Including module: base ***
*** Including module: fs-lib ***
*** Including module: shutdown ***
*** Including modules done ***
Failed to install module hv_netvsc

Broadcast message from systemd-journald@lvm (Sat 2023-02-11 21:28:02 UTC):

dracut[1846]: Failed to install module hv_netvsc

*** Installing kernel module dependencies and firmware ***

Message from syslogd@lvm at Feb 11 21:28:02 ...
 dracut:Failed to install module hv_netvsc
*** Installing kernel module dependencies and firmware done ***
*** Resolving executable dependencies ***
*** Resolving executable dependencies done***
*** Hardlinking files ***
*** Hardlinking files done ***
*** Stripping files ***
*** Stripping files done ***
*** Generating early-microcode cpio image contents ***
*** No early-microcode cpio image needed ***
*** Store current command line parameters ***
rm: cannot remove '/boot': Is a directory
*** Creating image file ***
*** Creating image file done ***
*** Creating initramfs image file '/boot' done ***
[root@lvm /]#   sed -i 's#rd.lvm.lv=vg_root/lv_root#rd.lvm.lv=VolGroup00/LogVol00#g' /boot/grub2/grub.cfg
[root@lvm /]# exit

```

#### This is final result

```bash
[vagrant@lvm ~]$ lsblk
NAME                     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                        8:0    0   40G  0 disk 
├─sda1                     8:1    0    1M  0 part 
├─sda2                     8:2    0    1G  0 part /boot
└─sda3                     8:3    0   39G  0 part 
  ├─VolGroup00-LogVol00  253:0    0    8G  0 lvm  /
  └─VolGroup00-LogVol01  253:1    0  1.5G  0 lvm  [SWAP]
sdb                        8:16   0   10G  0 disk 
└─vg_root-lv_root        253:3    0   10G  0 lvm  
sdc                        8:32   0    2G  0 disk 
├─vg_var-lv_var_rmeta_0  253:4    0    4M  0 lvm  
│ └─vg_var-lv_var        253:8    0 1016M  0 lvm  /var
└─vg_var-lv_var_rimage_0 253:5    0 1016M  0 lvm  
  └─vg_var-lv_var        253:8    0 1016M  0 lvm  /var
sdd                        8:48   0    1G  0 disk 
├─vg_var-lv_var_rmeta_1  253:6    0    4M  0 lvm  
│ └─vg_var-lv_var        253:8    0 1016M  0 lvm  /var
└─vg_var-lv_var_rimage_1 253:7    0 1016M  0 lvm  
  └─vg_var-lv_var        253:8    0 1016M  0 lvm  /var
sde                        8:64   0    2G  0 disk 
└─vg_home-lv_home        253:2    0    1G  0 lvm  /home
[vagrant@lvm ~]$ df -h
Filesystem                       Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup00-LogVol00  8.0G  922M  7.1G  12% /
devtmpfs                         110M     0  110M   0% /dev
tmpfs                            118M     0  118M   0% /dev/shm
tmpfs                            118M  4.6M  114M   4% /run
tmpfs                            118M     0  118M   0% /sys/fs/cgroup
/dev/mapper/vg_home-lv_home      976M  2.6M  907M   1% /home
/dev/sda2                       1014M   61M  954M   7% /boot
/dev/mapper/vg_var-lv_var       1013M  253M  761M  25% /var
tmpfs                             24M     0   24M   0% /run/user/1000
```

#### Requirements

Because vagrant manage disk only Virtualbox prvider:

* Vagrant
* Virtualbox
* `VAGRANT_EXPERIMENTAL="disks"` option enable

#### System requirements

1vCPU / 2Gb RAM / 25 gb free on your hypervisor host machine

#### Usage
1. Clone this repository on your host machine \
   `git clone https://github.com/u-kosmonaft-u/otus-task.git`
2. Go to the project directory \
   `cd otus-task/lesson_3`
4. Start virtual machine \
   `vagrant up`
5. Wait until all task in provisioning vm will be done
6. Connect to vm via ssh by running \
    `vagrant ssh`
7. Change dir to `tmp` \
    `cd /tmp`
8. Run script \
    `sudo ./task_lvm.sh`
9. To complete all task first run \
    `sudo ./reduce root`
11. Reboot vm \
    `reboot -h now`
12. Wait until machine boots up
13. Connect to VM one more time \
    `vagrant ssh`
14. And run another script \
    `cd /tmp && ./return_root.sh`
15. Reboot again \
    `reboot -h now`

#### Test

This code tested on <br>
* `AstraLinux SE 1.7`
* `Vagrant 2.2.19`