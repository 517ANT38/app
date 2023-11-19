#!/bin/bash

error_exit(){
    echo "error: $1"
}


cd app_start || error_exit 'Вы в каталоге app_start'
#установка необхомимых пакетов


packagesNeeded='curl jq firewalld net-tools postgresql-contrib postgresql'
if [ -x "$(command -v apk)" ];       then sudo apk add --no-cache $packagesNeeded
elif [ -x "$(command -v apt)" ];     then sudo apt update && sudo apt install $packagesNeeded
elif [ -x "$(command -v apt-get)" ]; then sudo apt-get update && sudo apt-get install $packagesNeeded
elif [ -x "$(command -v dnf)" ];     then sudo dnf install $packagesNeeded'-server'
elif [ -x "$(command -v zypper)" ];  then sudo zypper install $packagesNeeded
elif [ -x "$(command -v yum)" ];  then sudo yum install $packagesNeeded
else echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2; fi
sudo systemctl enable postgresql;
sudo postgresql-setup --initdb --unit postgresql
sudo systemctl start postgresql.service;


#запуск сервера postgres
sudo -u postgres psql -c "CREATE ROLE myapp LOGIN PASSWORD 'myapp'";

sudo -u postgres psql -c 'CREATE DATABASE appmarks' || echo 'БД appmarks уже существует'; 

sudo -u postgres psql -c 'ALTER ROLE myapp WITH SUPERUSER';
 


tp='host   all             myapp             localhost                   md5';

sudo chmod -R o+wrx /etc/postgresql
sudo chmod -R o+wrx /var/lib/pgsql
sudo echo $tp >> /etc/postgresql/**/main/pg_hba.conf || error_exit 'Файла нет';
sudo echo $tp >> /var/lib/pgsql/pg_hba.conf || error_exit 'Файла нет';

#Настройка портов
sudo firewall-cmd --permanent --add-port=8080/tcp 
sudo firewall-cmd --permanent --add-port=4567/tcp 
sudo firewall-cmd --reload

# зависимости приложения
cd ..
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
nvm install node
nvm install-latest-npm
npm install pm2 -g
cd app_marks 
npm install 

#запуск приложения
pm2 start -f --name app ./index.js 
pm2 save

cd ..

