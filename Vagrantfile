
  
Vagrant.configure("2") do |config|

  
  config.vm.synced_folder "app", "/home/vagrant/app"
  
   config.vm.define "main" do |main|
	 main.vm.box = "ubuntu/xenial64"
	 main.vm.provision "shell", path: "app/mainprovision.sh"
	 main.vm.network "private_network", ip: "192.168.10.100"
  end
  
   config.vm.define "db" do |db|
    db.vm.box = "ubuntu/xenial64"
	db.vm.provision "shell", path: "app/dbprovision.sh"
	db.vm.network "private_network", ip: "192.168.10.101"
  end
  
  end



