#!/bin/bash

# cd to root directory where server.js is located
cd /var/www/crud-app-test/api


# start node service --> always restart mode PORT 4000
npm run daemon

# start react service front PORT 3000
cd ../src
npm start
