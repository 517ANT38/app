#!/bin/bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
nvm install node
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql.service
sudo su postgres
psql  --file=app_start/create_database.sql
exit
cd app_marks
npm install
npm install pm2 -g
cd -
pm2 start -f --name app app_marks/index.js 
