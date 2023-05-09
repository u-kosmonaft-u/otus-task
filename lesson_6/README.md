# LESSON 6 PACKAGE DISTRIBUTION

### Tasks

* Create RPM package
* Create package repository

### Result

Vagrantfile

#### Requirements

Virtualbox prvider:

* Vagrant
* Virtualbox

#### System requirements

4vCPU and 8Gb RAM free on your hypervisor host machine

#### Usage
1. Clone this repository on your host machine \
   `git clone https://github.com/u-kosmonaft-u/otus-task.git`
2. Go to the project directory \
   `cd otus-task/lesson_6`
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
