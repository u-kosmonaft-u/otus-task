# LESSON 8 SystemD

### Tasks

* Write the monitoring log service with 30 s. delay check. Configured by config file in `/etc/sysconfig`
* Install `spawn-fcgi` & rewrite init-script to unit-file. Service name should be the same

### Result

Vagrantfile

#### Requirements

Virtualbox provider:

* Vagrant
* Virtualbox

#### System requirements

1vCPU and 2Gb RAM free on your hypervisor host machine

#### Usage
1. Clone this repository on your host machine \
   `git clone https://github.com/u-kosmonaft-u/otus-task.git`
2. Go to the project directory \
   `cd otus-task/lesson_8`
3. Start virtual machine \
   `vagrant up`
4. Wait until all task in provisioning vm will be done
   <br><br>
   After provision shell script should read test file and print a message
   into stdout: <br>
   * first task: <br>
   ```
   systemd: Jun  3 09:01:18 systemd root[15424]: : I found word, Master!
   ```
   * second task: <br>
   ```bash
   
    systemd: Complete!
    systemd: ● spawn-fcgi.service - Spawn-fcgi startup service by Otus
    systemd:    Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; vendor preset: disabled)
    systemd:    Active: active (running) since Sat 2023-06-03 09:01:47 UTC; 8ms ago
    systemd:  Main PID: 33843 (spawn-fcgi)
    systemd:     Tasks: 1 (limit: 5970)
    systemd:    Memory: 492.0K
    systemd:    CGroup: /system.slice/spawn-fcgi.service
    systemd:            └─33843 /usr/bin/php-cgi
   
   ```
   * third task: <br>
   ```bash
    systemd: ● httpd@first.service - The Apache HTTP Server
    systemd:    Loaded: loaded (/usr/lib/systemd/system/httpd@.service; disabled; vendor preset: disabled)
    systemd:    Active: active (running) since Sat 2023-06-03 13:35:38 UTC; 5ms ago
    systemd:      Docs: man:httpd(8)
    systemd:            man:apachectl(8)
    systemd:  Main PID: 14180 (httpd)
    systemd:    Status: "Processing requests..."
    systemd:    CGroup: /system.slice/system-httpd.slice/httpd@first.service
    systemd:            ├─14180 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
    systemd:            ├─14181 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
    systemd:            ├─14182 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
    systemd:            ├─14183 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
    systemd:            ├─14184 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
    systemd:            ├─14185 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
    systemd:            └─14186 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
   ...
    systemd: ● httpd@second.service - The Apache HTTP Server
    systemd:    Loaded: loaded (/usr/lib/systemd/system/httpd@.service; disabled; vendor preset: disabled)
    systemd:    Active: active (running) since Sat 2023-06-03 13:35:38 UTC; 6ms ago
    systemd:      Docs: man:httpd(8)
    systemd:            man:apachectl(8)
    systemd:  Main PID: 14203 (httpd)
    systemd:    Status: "Processing requests..."
    systemd:    CGroup: /system.slice/system-httpd.slice/httpd@second.service
    systemd:            ├─14203 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
    systemd:            ├─14204 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
    systemd:            ├─14205 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
    systemd:            ├─14206 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
    systemd:            ├─14207 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
    systemd:            ├─14208 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
    systemd:            └─14209 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
   ...
    systemd: tcp    LISTEN     0      128    [::]:8080               [::]:*                   users:(("httpd",pid=14209,fd=4),("httpd",pid=14208,fd=4),("httpd",pid=14207,fd=4),("httpd",pid=14206,fd=4),("httpd",pid=14205,fd=4),("httpd",pid=14204,fd=4),("httpd",pid=14203,fd=4))
    systemd: tcp    LISTEN     0      128    [::]:80                 [::]:*                   users:(("httpd",pid=14186,fd=4),("httpd",pid=14185,fd=4),("httpd",pid=14184,fd=4),("httpd",pid=14183,fd=4),("httpd",pid=14182,fd=4),("httpd",pid=14181,fd=4),("httpd",pid=14180,fd=4))
   
   ```
#### Test

This code tested on <br>
* `AstraLinux SE 1.7`
* `Vagrant 2.2.19`
