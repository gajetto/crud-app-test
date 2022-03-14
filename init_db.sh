#!/bin/bash

echo "launch script.."
echo "YUM UPDATE -Y"


until ping -c1 www.google.com &>/dev/null; do
    echo "Waiting for network ..."
    sleep 1
done

cd /home/ec2-user

sudo echo -e 'alias ll="ls -larth"
alias nets="sudo netstat -tlpn"
alias mong="sudo systemctl status mongod.service"' >> .bashrc

source .bashrc

sudo yum update -y

sudo chown -R ec2-user /etc/yum.repos.d/

sudo echo "WRITE INTO YUM MONGO REPO"

sudo echo -e "[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc" > /etc/yum.repos.d/mongodb-org-5.0.repo

echo "YUM INSTALL -Y MONGODB-ORG"

yum install -y mongodb-org

echo "START MONGODB SERVER"

systemctl start mongod.service

echo "CREATING REACT-DB DATABASE"

mongosh --eval 'use react-db'

mongoexport --uri mongodb+srv://gajetto:Hjh65gfds*Uds@cluster0.xi2k0.mongodb.net/react-db --collection employer --type json --out employer.json

mongoimport --db react-db --collection employer --file employer.json

chown ec2-user:ec2-user /etc/mongod.conf

echo -e 'db = db.getSiblingDB("react-db");
db.createUser({ user: "adminReact",
                pwd: "admin123456",
                roles: [ "readWrite", "dbAdmin", "dbOwner" ]
                });' > create_user.js

chmod +x create_user.js

echo "CREATED USER AUTH INSIDE MONGODB"

mongo create_user.js

sudo rm -f create_user.js

sed -i 's/#security:/security:/g' /etc/mongod.conf
sed -i '33iauthorization: enabled' /etc/mongod.conf
sed -i 's/authorization: enabled/  authorization: enabled/g' /etc/mongod.conf
sed -i 's/bindIp: 127.0.0.1/bindIp: 127.0.0.1, 10.0.1.50 /g' /etc/mongod.conf

systemctl restart mongod.service