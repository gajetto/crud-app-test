#!/bin/bash

yum update -y
mkdir -p /var/www/crud-app-test
chown -R ec2-user:ec2-user /var/www/

cd

echo -e 'alias ll="ls -larth"
alias nets="sudo netstat -tlpn"
alias app="cd /var/www/crud-app-test/"' >> .bashrc

source .bashrc


#Adding node 16x in yum repo 
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -

#Installing nodejs (same version as dev env)
sudo yum install nodejs -y

yum install -y ruby
yum install wget
wget https://aws-codedeploy-eu-west-3.s3.eu-west-3.amazonaws.com/latest/install
chmod +x ./install
./install auto
service codedeploy-agent start