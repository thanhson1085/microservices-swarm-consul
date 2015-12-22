#!/bin/bash

NODE_IP=172.20.20.12
TOKEN=acdb9dfa3ea6da0b0cfb2c819385fcd3

sudo su -

echo Fetching microservices-swarm-consul ...
git clone https://github.com/thanhson1085/microservices-swarm-consul.git  /build

echo Installing dependencies...
apt-get update && \
    apt-get install -y unzip curl wget

echo Fetching Consul...
cd /tmp/
wget https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_amd64.zip -O consul.zip

echo Installing Consul...
unzip consul.zip
chmod +x consul
mv consul /usr/bin/consul
mkdir /etc/consul.d
chmod a+w /etc/consul.d
cd /build/agent-two
cp init/consul-agent.conf /etc/init/
start consul-agent

echo Installing Docker ...
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" \
    > /etc/apt/sources.list.d/docker.list

apt-get update && \
    apt-get install -y linux-image-extra-$(uname -r)

apt-get update && \
    apt-get install -y docker-engine

echo Installing Docker Swarm...
docker pull swarm
docker run -d swarm join --addr=$NODE_IP:2375 token://$TOKEN
docker run -d -p 12375:2375 swarm manage token://$TOKEN

cp /build/node-two/docker /etc/default/docker
service docker restart

export DOCKER_HOST=tcp://$NODE_IP:12375
doker info

echo Running Registrator...
docker run -d \
    --name=registrator \
    --net=host \
    --volume=/var/run/docker.sock:/tmp/docker.sock \
    gliderlabs/registrator:latest \
    consul://$NODE_IP:8500

echo Running cAdvisor...
docker run --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:rw --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
    --publish=8080:8080 \
    --detach=true --name=cadvisor google/cadvisor:latest

