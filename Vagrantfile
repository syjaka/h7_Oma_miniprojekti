# -*- mode: ruby -*-
# vi: set ft=ruby :


$tscript_master = <<TSCRIPT
set -o verbose
apt-get update
apt-get -y install ufw curl micro bash-completion git ssh salt-master
sudo systemctl restart salt-master
echo "Master done"
TSCRIPT

$tscript_ufw = <<TSCRIPT
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 4505/tcp
ufw allow 4506/tcp
echo "y" | ufw enable
echo "Ufw config done and enabled"
TSCRIPT

$tscript_github = <<TSCRIPT
set -o verbose
git config --global user.email "kadriye.syrja@myy.haaga-helia.fi"
git config --global user.name "saltmaster"
echo "Git config done"
TSCRIPT

$tscript_webadmin = <<TSCRIPT
set -o verbose
apt-get update
apt-get -y install salt-minion tasksel
echo "master: 192.168.88.101" > /etc/salt/minion
echo "id: webadmin" >> /etc/salt/minion
echo "master_alive_interval: 30" >> /etc/salt/minion
sudo systemctl restart salt-minion
#install XFCE
sudo tasksel install xfce-desktop
echo "Webadmin done"
TSCRIPT

$tscript_webserver = <<TSCRIPT
set -o verbose
apt-get update
apt-get -y install salt-minion
echo "master: 192.168.88.101" > /etc/salt/minion
echo "id: webserver" >> /etc/salt/minion
echo "master_alive_interval: 30" >> /etc/salt/minion
sudo systemctl restart salt-minion
echo "Webserver done"
TSCRIPT

Vagrant.configure("2") do |config|
	config.vm.synced_folder ".", "/vagrant", disabled: true
	config.vm.synced_folder "shared/", "/home/vagrant/shared", create: true
	config.vm.box = "debian/bullseye64"
	
	config.vm.define "saltmaster" do |saltmaster|
		saltmaster.vm.hostname = "saltmaster"
		saltmaster.vm.network "private_network", ip: "192.168.88.101"
		saltmaster.vm.provision "shell", inline: $tscript_master
		saltmaster.vm.provision "shell", inline: $tscript_ufw
		saltmaster.vm.provision "shell", inline: $tscript_github
	end
	
	config.vm.define "webadmin", primary: true do |webadmin|
	     webadmin.vm.hostname = "webadmin"
	     webadmin.vm.network "private_network", ip: "192.168.88.102"
	     webadmin.vm.provision "shell", inline: $tscript_ufw
	     webadmin.vm.provision "shell", inline: $tscript_webadmin
	     webadmin.vm.provider "virtualbox" do |vb|
		vb.gui = true
		vb.memory = "2048"
	     end	
	end
	
	config.vm.define "webserver", primary: true do |webserver|
	      webserver.vm.hostname = "webserver"
	      webserver.vm.network "private_network", ip: "192.168.88.103"
	      webserver.vm.provision "shell", inline: $tscript_ufw
	      webserver.vm.provision "shell", inline: $tscript_webserver
			 webserver.vm.provider "virtualbox" do |vb|
		 vb.gui = false
		 vb.memory = "1024"
	      end
	end

end
