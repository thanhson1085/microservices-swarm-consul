#!/bin/bash

sudo su -

echo Fetching microservices-swarm-consul ...
git clone https://github.com/thanhson1085/microservices-swarm-consul.git  /build
cd /build/agent-two
cp init/*.conf /etc/init/

echo Installing dependencies...
apt-get update && \
    apt-get install -y unzip curl wget

echo Fetching Consul...
cd /tmp/
wget https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip -O consul.zip

echo Installing Consul...
unzip consul.zip
chmod +x consul
mv consul /usr/bin/consul
cp -R /build/agent-two/consul.d /etc/
start consul-agent

echo Installing Docker ...
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" \
    > /etc/apt/sources.list.d/docker.list

apt-get update && \
    apt-get install -y linux-image-extra-$(uname -r)

apt-get update && \
    apt-get install -y docker-engine

cp /build/agent-two/docker /etc/default/docker
# issues/18113
rm -rf /var/lib/docker/network/files/local-kv.db
service docker restart

echo Installing Docker Compose
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo Running Registrator...
start docker-registrator

echo Running cAdvisor...
start docker-cadvisor


echo Installing Docker Swarm...
docker pull swarm
start swarm-join

echo Pulling angular-admin-seed...
docker pull thanhson1085/angular-admin-seed:mysql
