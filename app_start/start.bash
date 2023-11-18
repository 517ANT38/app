#!/bin/bash


sudo apt update
sudo apt install postgresql postgresql-contrib curl

sudo systemctl start postgresql.service
sudo su postgres
psql --file=app_start/create_database.sql
exit
# зависимости приложения
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
nvm install node
cd app_marks
npm install
npm install pm2 -g
#запуск приложения
cd -
pm2 start -f --name app app_marks/index.js 


