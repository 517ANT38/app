#!/bin/bash

error_exit(){
    echo "error: $1"
}


cd app_start || error_exit 'Вы в каталоге app_start'
#установка необхомимых пакетов


pd='curl jq firewalld net-tools'
pp='postgresql-contrib postgresql'
function install_packages(){
    if [ -x "$(command -v apk)" ];       then sudo apk add --no-cache $1
    elif [ -x "$(command -v apt)" ];     then sudo apt update && sudo apt install $1
    elif [ -x "$(command -v apt-get)" ]; then sudo apt-get update && sudo apt-get install $1
    elif [ -x "$(command -v dnf)" ];     then sudo dnf install $1'-server'
    elif [ -x "$(command -v zypper)" ];  then sudo zypper install $1
    elif [ -x "$(command -v yum)" ];  then sudo yum install $1
    else echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $1">&2; fi
}

# Проверяем, установлен ли пакет postgresql
if dpkg -s postgresql >/dev/null 2>&1; then
    
    install_packages $pp;
    sudo systemctl enable postgresql;
    sudo postgresql-setup --initdb --unit postgresql

    sudo chmod -R o+wrx /etc/postgresql
    sudo chmod 0750 o+wrx /etc/postgresql/**/data

    sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/**/main/pg_hba.conf || error_exit 'Файла нет'; 
    sudo echo 'all all all all trust' >> /etc/postgresql/**/main/pg_hba.conf || error_exit 'Файла нет';
    sudo systemctl start postgresql.service;
else
    echo "Сервер PostgreSQL установлен."
fi

install_packages $pd

#запуск сервера postgres
sudo -u postgres psql -c "CREATE ROLE myapp LOGIN PASSWORD 'myapp'";

sudo -u postgres psql -c 'CREATE DATABASE appmarks' || echo 'БД appmarks уже существует'; 

sudo -u postgres psql -c 'ALTER ROLE myapp WITH SUPERUSER';
 



#Настройка портов
sudo firewall-cmd --permanent --add-port=8080/tcp 
sudo firewall-cmd --permanent --add-port=4567/tcp 
sudo firewall-cmd --reload

# зависимости приложения
cd /
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
nvm install node
nvm install-latest-npm
npm install pm2 -g
cd ~/app
cd app_marks 
npm install 

#запуск приложения
pm2 start -f --name app ./index.js 
pm2 save


