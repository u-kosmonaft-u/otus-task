#!/usr/bin/env bash
sudo -i && cd /root
# Prepare generic Centos 8
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
yum update -y

# Install necessary packages
yum install -y redhat-lsb-core \
                    wget \
                    rpmdevtools \
                    rpm-build \
                    createrepo \
                    yum-utils \
                    gcc

# Download source code rpm pkg
wget https://nginx.org/packages/centos/8/SRPMS/nginx-1.20.2-1.el8.ngx.src.rpm

# Download openssl zip archive
wget https://github.com/openssl/openssl/archive/refs/heads/OpenSSL_1_1_1-stable.zip
unzip OpenSSL_1_1_1-stable.zip

# Unpack nginx source code
rpm -i nginx-1.*

# Install building dependencies
yum-builddep -y rpmbuild/SPECS/nginx.spec

# Add OpenSSl to spec
sed -i.bak '114i\    --with-openssl=/root/openssl-OpenSSL_1_1_1-stable \\' rpmbuild/SPECS/nginx.spec

# Build nginx pkg
rpmbuild -bb rpmbuild/SPECS/nginx.spec

# Install && start nginx
yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el8.ngx.x86_64.rpm
systemctl start nginx
systemctl status nginx

# Make repo dir
mkdir /usr/share/nginx/html/repo

# Copy package to repo
cp /root/rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el8.ngx.x86_64.rpm /usr/share/nginx/html/repo

# Download persona rpm pkg
wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.0.28/binary/redhat/8/x86_64/percona-orchestrator-3.2.6-2.el8.x86_64.rpm \
 -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-2.el8.x86_64.rpm

# Create repository
createrepo /usr/share/nginx/html/repo/

# Change nginx config
sed -i.bak '10i\        autoindex on;' /etc/nginx/conf.d/default.conf

# restart nginx
nginx -t && nginx -s reload

# Add local repository
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

# Check repo is available
yum repolist enabled | grep otus

# Install persona orchestrator
yum install percona-orchestrator.x86_64 -y
