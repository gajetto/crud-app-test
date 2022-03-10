#!/bin/bash

cd /var/www/api
# install forever module for service availaibility
npm install -g --save forever 

npm run daemon

cd ../src

npm start
