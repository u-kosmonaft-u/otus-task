# LESSON 2 RAID

### Task
Build the RAID and mount it to filesystem, also break it and fix it

### Result
Ubuntu 20.04-box based Vagrantfile and `raid.sh` script. <br>
```bash
 mdadm-raid: Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
    mdadm-raid: md0 : active raid6 sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
    mdadm-raid:       15713280 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]
    mdadm-raid: 
    mdadm-raid: unused devices: <none>
    mdadm-raid: /dev/md0:
    mdadm-raid:            Version : 1.2
    mdadm-raid:      Creation Time : Mon Jan 23 15:05:58 2023
    mdadm-raid:         Raid Level : raid6
    mdadm-raid:         Array Size : 15713280 (14.99 GiB 16.09 GB)
    mdadm-raid:      Used Dev Size : 5237760 (5.00 GiB 5.36 GB)
    mdadm-raid:       Raid Devices : 5
    mdadm-raid:      Total Devices : 5
    mdadm-raid:        Persistence : Superblock is persistent
    mdadm-raid: 
    mdadm-raid:        Update Time : Mon Jan 23 15:06:45 2023
    mdadm-raid:              State : active
    mdadm-raid:     Active Devices : 5
    mdadm-raid:    Working Devices : 5
    mdadm-raid:     Failed Devices : 0
    mdadm-raid:      Spare Devices : 0
    mdadm-raid: 
    mdadm-raid:             Layout : left-symmetric
    mdadm-raid:         Chunk Size : 512K
    mdadm-raid: 
    mdadm-raid: Consistency Policy : resync
    mdadm-raid: 
    mdadm-raid:               Name : mdadm-raid:0  (local to host mdadm-raid)
    mdadm-raid:               UUID : e7dace37:6be7afbf:5e845209:74659998
    mdadm-raid:             Events : 24
    mdadm-raid: 
    mdadm-raid:     Number   Major   Minor   RaidDevice State
    mdadm-raid:        0       8       16        0      active sync   /dev/sdb
    mdadm-raid:        1       8       32        1      active sync   /dev/sdc
    mdadm-raid:        2       8       48        2      active sync   /dev/sdd
    mdadm-raid:        3       8       64        3      active sync   /dev/sde
    mdadm-raid:        4       8       80        4      active sync   /dev/sdf
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
   `cd otus-task/lesson_2`
4. Start virtual machine \
   `vagrant up`
5. Wait until all task in provisioning vm will be done
6. If you vant to login into VM just use \
   `vagrant ssh`

#### Test

This code tested on <br>
* `AstraLinux SE 1.7`
* `Vagrant 2.2.19`