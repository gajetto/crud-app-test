#!/bin/bash

cd /var/www/crud-app-test


#################################################### EC2 IP ADDRESS SED ##############################################################################

cd /var/www/crud-app-test/src/components

IPADDRESS=$(curl http://checkip.amazonaws.com)

sudo sed -i 's|localhost|'$IPADDRESS'|g' TableRow.js index.component.js create.component.js edit.component.js

# npm install -g npm@latest

npm install --global yarn

################################################## NODE DEPENDENCIES ################################################################

cd /var/www/crud-app-test/api

npm install

################################################# REACT DEPENDENCIES ####################################################################

cd /var/www/crud-app-test/src


# npm config set package-lock false
npm i --save-dev core-js@3 @babel/runtime-corejs3

npm install --save @babel/runtime-corejs3

yarn install