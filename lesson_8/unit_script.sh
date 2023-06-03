#!/usr/bin/env bash
######################
##      PART I      ##
######################
# Prepare generic Centos 8

sudo -i
#sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
#sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
yum update -y

# Create configuration file
cat >> /etc/sysconfig/watchlog.cfg << EOF
WORD="ALERT"
LOG=/var/log/watchlog.log
EOF

# Fulfill log file
for i in {1..3}; do echo "This is test line number $i" >> /var/log/watchlog.log; done
echo "Something go wrong! ALERT!" >> /var/log/watchlog.log
for i in {4..6}; do echo "This is test line number $i" >> /var/log/watchlog.log; done
echo "Something go wrong! ALERT!" >> /var/log/watchlog.log

# Create script
cat >> /opt/watchlog.sh << EOF
#!/bin/bash

WORD=\$1
LOG=\$2
DATE=\`date\`

if grep \$WORD \$LOG &> /dev/null
then
logger "$DATE: I found word, Master!"
else
exit 0
fi
EOF

# Make script executable
chmod +x /opt/watchlog.sh

# Create unit files
cat >> /etc/systemd/system/watchlog.service << EOF
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog.cfg
ExecStart=/opt/watchlog.sh \$WORD \$LOG
EOF

# Create timer file
cat >> /etc/systemd/system/watchlog.timer << EOF
[Unit]
Description=Run watchlog script every 30 second

[Timer]
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
EOF

# Start timer
systemctl daemon-reload
systemctl start watchlog.timer && systemctl enable watchlog.timer
systemctl start watchlog.service && systemctl enable watchlog.service
sleep 5
cat /var/log/messages | grep -i master
######################
##     PART II      ##
######################
# Install pkgs
yum install -y epel-release
yum install -y spawn-fcgi php php-cli mod_fcgid

# Remove old config
rm -f /etc/sysconfig/spawn-fcgi

# Add new config
cat >> /etc/sysconfig/spawn-fcgi << EOF
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u apache -g apache -s $SOCKET -S -M 0600 -C 32 -F 1 -- /usr/bin/php-cgi"
EOF

# Create unit service
cat >> /etc/systemd/system/spawn-fcgi.service << EOF
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target
[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n \$OPTIONS
KillMode=process
[Install]
WantedBy=multi-user.target
EOF

# Reload daemons && start service && check status
systemctl daemon-reload
systemctl start spawn-fcgi.service && systemctl status spawn-fcgi.service

######################
##    PART III      ##
######################

# Create new template unit file
systemctl stop httpd
cp /usr/lib/systemd/system/httpd.service /usr/lib/systemd/system/httpd@.service
sed -i '9 s/httpd/httpd-%I/1' /usr/lib/systemd/system/httpd@.service

for (( i = 0; i < 2; i++ )); do
  if [ "$i" == 0 ]; then
      COUNT=first
      cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/$COUNT.conf
  elif [ "$i" == 1  ]; then
      COUNT=second
      cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/$COUNT.conf
      sed -i "42 s/80/8080/1" /etc/httpd/conf/$COUNT.conf
  fi
  sed -i "43iPidFile  \/var\/run\/httpd-$COUNT.pid" /etc/httpd/conf/$COUNT.conf
  cp /etc/sysconfig/httpd /etc/sysconfig/httpd-$COUNT
  sed -i "17 s/#OPTIONS=/OPTIONS=-f conf\/$COUNT.conf/1"  /etc/sysconfig/httpd-$COUNT
  systemctl start httpd@$COUNT
  systemctl status httpd@$COUNT
  ss -tulpan | grep httpd
done