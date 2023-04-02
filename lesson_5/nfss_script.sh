#!/bin/bash

# Raise up to root
sudo -i

# Install nfs
yum install -y nfs-utils

# Turn firewall on
systemctl enable firewalld --now
systemctl status firewalld

# Add firewall rules
firewall-cmd --add-service="nfs3" \
  --add-service="rpc-bind" \
  --add-service="mountd" \
  --permanent

# Reload firewall
firewall-cmd --reload

# Enable nfs
systemctl enable nfs --now

# Create share point, change owner rights, create check file
mkdir -p /srv/share/upload
chown -R nfsnobody:nfsnobody /srv/share
echo "All done!" > /srv/share/upload/check_file
chmod -R 0777 /srv/share/upload

# Add share dir to config
cat << EOF > /etc/exports
/srv/share 192.168.50.11/32(rw,sync,root_squash)
EOF

# Exporting
exportfs -r
exportfs -s
