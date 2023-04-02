# LESSON 5 NFS

### Tasks

* Up two VM with NFS server & NFS client
* Share dir on server, automount in client
* Share dir should contain upload dir with +w
* NFSv3 by UDP
* Firewall on

### Result

Vagrantfile

#### Requirements

Virtualbox prvider:

* Vagrant
* Virtualbox

#### System requirements

1vCPU and 2Gb RAM free on your hypervisor host machine

#### Usage
1. Clone this repository on your host machine \
   `git clone https://github.com/u-kosmonaft-u/otus-task.git`
2. Go to the project directory \
   `cd otus-task/lesson_5`
4. Start virtual machine \
   `vagrant up`
5. Wait until all task in provisioning vm will be done
<br><br>
Afrter provision shell script should read test file and print a message
into stdout: <br>
```nfsc: All done!```
#### Test

This code tested on <br>
* `AstraLinux SE 1.7`
* `Vagrant 2.2.19`
