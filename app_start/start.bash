#!/bin/bash

#установка необхомимых пакетов
packagesNeeded='curl jq postgresql-server postgresql-contrib'
if [ -x "$(pg_config --version)" ]; then
    if [ -x "$(command -v apk)" ];       then sudo apk add --no-cache $packagesNeeded
    elif [ -x "$(command -v apt)" ];     then sudo apt update && sudo apt install $packagesNeeded
    elif [ -x "$(command -v apt-get)" ]; then sudo apt-get update && sudo apt-get install $packagesNeeded
    elif [ -x "$(command -v dnf)" ];     then sudo dnf install $packagesNeeded
    elif [ -x "$(command -v zypper)" ];  then sudo zypper install $packagesNeeded
    elif [ -x "$(command -v yum)" ];  then sudo yum install $packagesNeeded
    else echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2; fi
    sudo systemctl enable postgresql;
    sudo postgresql-setup --initdb --unit postgresql
    sudo systemctl start postgresql.service;
fi
#запуск сервера postgres

sudo -i -u postgres;
psql -c 'CREATE DATABASE appmarks'; 
exit;
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
pm2 save



