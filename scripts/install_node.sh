#!/bin/bash

cd /var/www/react-crud-app
sudo npm install -g npm@8.5.3
npm install

# install forever module for service availaibility
sudo npm install -g --save forever 

# Install dependencies on react front
cd /api
npm install

echo -e "SKIP_PREFLIGHT_CHECK=true
DB_PASSWORD=admin123456 
DB_USER=adminReact 
DB_NAME=mongodb://10.0.1.50/react-db?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+1.2.
DEBUGLEVEL=5" > /.env

cd ../src/components

IPADDRESS=$(curl http://checkip.amazonaws.com)

sudo sed -i 's|localhost|$IPADDRESS|g' TableRow.js index.component.js create.component.js edit.component.js