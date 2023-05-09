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
```bash
    rpmp: otus                            otus-linux
    rpmp: otus-linux                                      1.0 MB/s | 2.8 kB     00:00
    rpmp: Dependencies resolved.
    rpmp: ================================================================================
    rpmp:  Package                   Arch        Version             Repository      Size
    rpmp: ================================================================================
    rpmp: Installing:
    rpmp:  percona-orchestrator      x86_64      2:3.2.6-2.el8       otus           5.0 M
    rpmp: Installing dependencies:
    rpmp:  jq                        x86_64      1.5-12.el8          appstream      161 k
    rpmp:  oniguruma                 x86_64      6.8.2-2.el8         appstream      187 k
    rpmp: 
    rpmp: Transaction Summary
    rpmp: ================================================================================
    rpmp: Install  3 Packages
    rpmp: 
    rpmp: Total download size: 5.3 M
    rpmp: Installed size: 17 M
    rpmp: Downloading Packages:
    rpmp: (1/3): percona-orchestrator-3.2.6-2.el8.x86_64. 161 MB/s | 5.0 MB     00:00
    rpmp: (2/3): jq-1.5-12.el8.x86_64.rpm                 744 kB/s | 161 kB     00:00
    rpmp: (3/3): oniguruma-6.8.2-2.el8.x86_64.rpm         847 kB/s | 187 kB     00:00
    rpmp: --------------------------------------------------------------------------------
    rpmp: Total                                            24 MB/s | 5.3 MB     00:00
    rpmp: Running transaction check
    rpmp: Transaction check succeeded.
    rpmp: Running transaction test
    rpmp: Transaction test succeeded.
    rpmp: Running transaction
    rpmp:   Preparing        :                                                        1/1
    rpmp:   Installing       : oniguruma-6.8.2-2.el8.x86_64                           1/3
    rpmp:   Running scriptlet: oniguruma-6.8.2-2.el8.x86_64                           1/3
    rpmp:   Installing       : jq-1.5-12.el8.x86_64                                   2/3
    rpmp:   Installing       : percona-orchestrator-2:3.2.6-2.el8.x86_64              3/3
    rpmp:   Running scriptlet: percona-orchestrator-2:3.2.6-2.el8.x86_64              3/3
    rpmp:   Verifying        : jq-1.5-12.el8.x86_64                                   1/3
    rpmp:   Verifying        : oniguruma-6.8.2-2.el8.x86_64                           2/3
    rpmp:   Verifying        : percona-orchestrator-2:3.2.6-2.el8.x86_64              3/3
    rpmp: 
    rpmp: Installed:
    rpmp:   jq-1.5-12.el8.x86_64                          oniguruma-6.8.2-2.el8.x86_64
    rpmp:   percona-orchestrator-2:3.2.6-2.el8.x86_64
    rpmp: 
    rpmp: Complete!
```
#### Test

This code tested on <br>
* `AstraLinux SE 1.7`
* `Vagrant 2.2.19`
