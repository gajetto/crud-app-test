#!/bin/bash

# move .env_prod file for db authentication
mv /tmp/scp/github/workspace/.env /var/www/crud-app-test/api

cd /var/www/crud-app-test/api
# install forever module for service availaibility
npm install -g --save forever 

# npm install pm2@latest -g

npm run daemon

cd ../src
# sudo pm2 start ‘npm start.’
npm start

echo "started successfully AMAZING"