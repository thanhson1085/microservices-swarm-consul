# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provision "shell", inline: <<-SHELL
     sudo apt-get update
     sudo apt-get install -y whois git
     sudo useradd -m -p `mkpasswd password` -s /bin/bash thanhson1085
     sudo usermod -a -G sudo thanhson1085
  SHELL

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.define "gateway" do |gateway|
      gateway.vm.hostname = "gateway"
      gateway.vm.network "private_network", ip: "172.20.20.10"
      gateway.vm.provision :shell, path: "gateway/run.sh"
  end

  config.vm.define "agent-one" do |n1|
      n1.vm.hostname = "agent-one"
      n1.vm.network "private_network", ip: "172.20.20.11"
      n1.vm.provision :shell, path: "agent-one/run.sh"
  end

  config.vm.define "agent-two" do |n2|
      n2.vm.hostname = "agent-two"
      n2.vm.network "private_network", ip: "172.20.20.12"
      n2.vm.provision :shell, path: "agent-two/run.sh"
  end
end
