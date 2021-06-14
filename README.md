# multiMachineVagrant

A project using 2 machines with vagrant, one hosting a node.js app and the other hosting a mongodb.

## Setting up 2 machines in the Vagrantfile

Inside the Vagrantfile, 2 machines can be set up as follows:
```
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
```
In this example, we make 2 machines called main and db. Config for one speciifc machine can be set using the machine's name, or generic config can be set using `config.vm.x`.

## Provision file

The machines are configured to use their own provision  files for unique setup configs. For the main/app machine: 
```
#!/bin/bash
sudo apt-get update -y

sudo apt-get upgrade -y

sudo  apt-get install nginx -y

sudo systemctl enable nginx

sudo apt-get install nodejs -y

sudo apt-get install npm-y

sudo apt-get install python-software-properties

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash

sudo apt-get install nodejs -y

sudo npm install pm2 -g

npm install
```
Again this stops short of lauching the app to allow the db to be configured:

``` #!/bin/bash
 
# be careful of these keys, they will go out of date
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list



sudo apt-get update -y
sudo apt-get upgrade -y



# sudo apt-get install mongodb-org=3.2.20 -y
sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20



# remoe the default .conf and replace with our configuration
sudo rm /etc/mongod.conf
```

The last few automated lines are omitted as I was having trouble automating them.
The `mongod.conf` file at `cd /etc` should be replaced with:
```
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
#  engine:
#  mmapv1:
#  wiredTiger:

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0


#processManagement:

#security:

#operationProfiling:

#replication:

#sharding:

## Enterprise-Only Options:

#auditLog:

#snmp:
```
Now doing 
```
sudo systemctl restart mongod
sudo systemctl enable mongod
```
Should bring up the db.

SSHing into the main/app machine, an enviroment variable shouold be set up as follows:
`export DB_HOST=mongodb://192.168.10.150:27017/posts`
This can be added to the provision to persist it or placed into the `./bashrc` file.
It may be necessary to seed the db using 
`cd app/seeds/
node seed.js`
Now doing `npm start` and navigating to 192.168.10.101:3000/posts (omitting port if reverse proxy setup) and the posts should be visible.
