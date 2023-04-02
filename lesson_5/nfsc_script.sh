#!/bin/bash

# Raise up to root
sudo -i

# Install nfs
yum install -y nfs-utils

# Enable firewall
systemctl enable firewalld --now
systemctl status firewalld

# Add automount point to fstab
echo "192.168.50.10:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab

# Reload daemons and restart target
systemctl daemon-reload && systemctl restart remote-fs.target

# Check successful mount
mount | grep mnt

# Final check
cat /mnt/upload/check_file
