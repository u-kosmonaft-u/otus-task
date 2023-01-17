# LESSON 1 Linux Kernel

### Task
Update linux to newest vanilla kernel

### Result
Centos7 with latest vanila kernel (6.1)<br>
`uname -r` command result `6.1.6-1.el7.elrepo.x86_64`

#### Requirements

* Vagrant
* vmWare fusion
* vagrant-vmware-desktop >= 1.0.0

#### System requirements

1vCPU and 2Gb RAM free on your hypervisor host machine

#### Usage
1. Clone this repository on your host machine \
   `git clone https://github.com/u-kosmonaft-u/otus-task.git`
2. Go to the project directory \
   `cd otus-task/lesson_1`
4. Start virtual machine \
   `vagrant up`
5. Wait until all task in provisioning vm will be done
6. If you vant to login into VM just use \
   `vagrant ssh`
##### Building box
1. Go to the packer directory \
   `cd packer`
2. Rub build process \
   `packer build centos.json`
3. Wait until build will be over
4. Add box to vagrant \
   `vagrant box add centos-7vmware.box --name centos7-6.1`
5. Run vm from box \
   `vagrant init centos7-6.1 && vagrant up`

#### Test

This code tested on <br>
* `macOS 13.1 (22C65) Intel`
* `Vagrant 2.3.4`
* `packer 1.8.5`
* `vmWare Fusion 12.2.4 (20071091)`
