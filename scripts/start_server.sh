#!/bin/bash

cd /var/www/api

npm run daemon

cd ../src

npm start
