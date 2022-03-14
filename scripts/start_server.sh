#!/bin/bash

cd /var/www/crud-app-test/api
# install forever module for service availaibility
npm install -g --save forever 

# npm install pm2@latest -g

npm run daemon

cd ../src
# sudo pm2 start ‘npm start.’
npm start

echo "started successfully AMAZING"