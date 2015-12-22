#!/bin/bash
sudo su -

echo Installing dependencies...
apt-get update && \
    apt-get install -y unzip curl wget nginx

echo Fetching Consul...
cd /tmp/
wget https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_amd64.zip -O consul.zip

echo Installing Consul...
unzip consul.zip
chmod +x consul
mv consul /usr/bin/consul
mkdir /etc/consul.d
chmod a+w /etc/consul.d

echo Fetching Consul UI...
cd /opt
mkdir consul
cd /opt/consul
wget https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_web_ui.zip -O consul_web_ui.zip
unzip consul_web_ui.zip

echo Fetching Consul Template...
mkdir consul-template
cd consul-template
cd /tmp/
wget https://releases.hashicorp.com/consul-template/0.12.0/consul-template_0.12.0_linux_amd64.zip -O consul-template.zip

echo Installing Consul Template...
unzip consul-template.zip
chmod +x consul-template
mv consul-template /usr/bin/consul-template

echo Fetching microservices-swarm-consul ...
git clone https://github.com/thanhson1085/microservices-swarm-consul.git  /build
cd /build/gateway/
cp init/consul-server.conf /etc/init/
cp init/consul-template.conf /etc/init/
start consul-server
start consul-template

