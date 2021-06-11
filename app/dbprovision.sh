#!/bin/bash
 
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add 
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list 
sudo apt-get update -y 
sudo apt-get upgrade -y 
sudo apt-get install -y mongodb-org 
sudo rm /etc/mongod.conf 
sudo ln -s /home/vagrant/app/mongod.conf /etc/mongod.conf