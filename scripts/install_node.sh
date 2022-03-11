#!/bin/bash

cd /var/www/crud-app-test


#################################################### EC2 IP ADDRESS SED ##############################################################################

cd /var/www/crud-app-test/src/components

IPADDRESS=$(curl http://checkip.amazonaws.com)

sudo sed -i 's|localhost|'$IPADDRESS'|g' TableRow.js index.component.js create.component.js edit.component.js

npm install -g npm@latest

################################################## NODE DEPENDENCIES ################################################################

cd /var/www/crud-app-test/api

npm install

# echo -e "SKIP_PREFLIGHT_CHECK=true
# DB_PASSWORD=admin123456 
# DB_USER=adminReact 
# DB_NAME=mongodb://10.0.1.50/react-db?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+1.2.
# DEBUGLEVEL=5" > .env



################################################# REACT DEPENDENCIES ####################################################################

cd /var/www/crud-app-test/src

npm i --save-dev core-js@3 @babel/runtime-corejs3
npm install