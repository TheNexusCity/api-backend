#!/bin/bash

#give permission for everything in the api-backend directory
sudo chmod -R 777 /opt/api-backend

#navigate into our working directory where we have all our github files
cd /opt/api-backend


#install node modules
npm install

#start our node app in the background using PM2
#pm2 --name api-backend start "npm run dev"
pm2 restart all