# LESSON 4 ZFS

### Tasks

- Determine the algorithm with the best compression Determine which compression algorithms zfs supports <br>
  (gzip, zle, lzjb, lz4); Create 4 file systems on each apply its own compression algorithm;
- Define pool settings Use the zfs import command to build the ZFS pool; <br>
  Use the zfs commands to define the settings: <br>
   * Storage size
   * Pool type
   * Recordsize value
   * Compression type
   * Checksum type
- Snapshot work
   * Copy file from remote source
   * Restore file locally
   * Find encrypted message in `secret_message`

### Result
Bash script in lesson directory to complete all tasks.

#### Requirements

Because vagrant manage disk only Virtualbox prvider:

* Vagrant
* Virtualbox
* `VAGRANT_EXPERIMENTAL="disks"` option enable

#### System requirements

1vCPU and 2Gb RAM free on your hypervisor host machine

#### Usage
1. Clone this repository on your host machine \
   `git clone https://github.com/u-kosmonaft-u/otus-task.git`
2. Go to the project directory \
   `cd otus-task/lesson_4`
4. Start virtual machine \
   `vagrant up`
5. Wait until all task in provisioning vm will be done

#### Test

This code tested on <br>
* `AstraLinux SE 1.7`
* `Vagrant 2.2.19`
