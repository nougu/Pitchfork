#!/bin/sh

tee /etc/yum.repos.d/docker.repo <<-_EOF_
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
_EOF_

yum install -q -y docker-engine

dotddir=/etc/systemd/system/docker.service.d
mkdir -p ${dotddir}
proxyconf=${dotddir}/http_proxy.conf
grep -q "HTTP_PROXY" ${proxyconf} || cat > ${proxyconf} <<EOS
[Service]
Environment="HTTP_PROXY=http://utrhira:1119292258@rep.proxy.nic.fujitsu.com:8080"
EOS

systemctl start docker

curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

