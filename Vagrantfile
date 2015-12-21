# vi: set ft=ruby :
$script = <<SCRIPT
echo Installing dependencies...
sudo apt-get update && apt-get install -y unzip curl wget
echo Fetching Consul...
cd /tmp/
wget https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip -O consul.zip
echo Installing Consul...
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul
sudo mkdir /etc/consul.d
sudo chmod a+w /etc/consul.d
SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provision "shell", inline: $script

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.define "gateway" do |gateway|
      gateway.vm.hostname = "gateway"
      gateway.vm.network "private_network", ip: "172.20.20.10"
      gateway.vm.provision "shell", inline: $script_gateway
  end

  config.vm.define "agent-one" do |n1|
      n1.vm.hostname = "agent-one"
      n1.vm.network "private_network", ip: "172.20.20.11"
      n1.vm.provision "shell", inline: $script_n1
  end

  config.vm.define "agent-two" do |n2|
      n2.vm.hostname = "agent-two"
      n2.vm.network "private_network", ip: "172.20.20.12"
      n2.vm.provision "shell", inline: $script_n2
  end
end
