#!/bin/bash

sudo yum update -y
sudo mkdir -p /var/www/crud-app-test
csudo hown -R ec2-user:ec2-user /var/www/

cd

sudo echo -e 'alias ll="ls -larth"
alias nets="sudo netstat -tlpn"
alias app="cd /var/www/crud-app-test/"' >> .bashrc

source .bashrc


#Adding node 16x in yum repo 
sudo curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -

#Installing nodejs (same version as dev env)
sudo yum install nodejs -y

sudo yum install -y ruby
sudo yum install wget
sudo wget https://aws-codedeploy-eu-west-3.s3.eu-west-3.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start