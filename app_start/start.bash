#!/bin/bash

error_exit(){
    echo "error: $1">&2
    exit 1
}

export -f error_exit

if ! [ -x "$(command -v sudo)" ];  then
    error_exit 'Sudo not found'
fi

cd $(dirname $0) || error_exit '';
#установка необхомимых пакетов


pd='curl jq firewalld net-tools'
function install_packages(){    
    if [ -x "$(command -v apt)" ];     then sudo apt update && sudo apt install $1
    elif [ -x "$(command -v apt-get)" ]; then sudo apt-get update && sudo apt-get install $1
    elif [ -x "$(command -v dnf)" ];     then sudo dnf install $1
    elif [ -x "$(command -v yum)" ];  then sudo yum install $1
    else error_exit "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $1"; fi
}

function init_db_elem(){
    sudo -u postgres psql -c "CREATE ROLE myapp LOGIN PASSWORD 'myapp'" || error_exit 'Такая роль уже существует';

    sudo -u postgres psql -c 'CREATE DATABASE appmarks' || error_exit 'БД appmarks уже существует'; 

    sudo -u postgres psql -c 'ALTER ROLE myapp WITH SUPERUSER';
}

# Проверяем, установлен ли пакет postgresql
if [ -x "$(command -v postgres -V)" ]; then    
    echo "Сервер PostgreSQL установлен."
else

    if [ [ -x "$(command -v dnf)" ] || [ -x "$(command -v yum)" ] ]; then 
        install_packages 'postgresql-server';
        sudo systemctl start postgresql;
        init_db_elem;
        sudo sed -i "s,#listen_addresses = 'localhost',listen_addresses = '*',g" /var/lib/pgsql/data/postgresql.conf
        echo "host all all 0.0.0.0/0 md5" | sudo tee -a /var/lib/pgsql/data/pg_hba.conf

    else
        install_packages 'postgresql';
        init_db_elem;
        sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/$(ls /etc/postgresql | awk '{printf $1}')/main/postgresql.conf
        sudo sh -c "echo \"host    all    all    0.0.0.0/0    md5\" >> /etc/postgresql/$(ls /etc/postgresql | awk '{printf $1}')/main/pg_hba.conf"
    fi
    sudo systemctl restart postgresql    
fi

install_packages $pd

#запуск сервера postgres

 



#Настройка портов
sudo firewall-cmd --permanent --add-port=8080/tcp 
sudo firewall-cmd --permanent --add-port=4567/tcp 
sudo firewall-cmd --reload

# зависимости приложения
cd ~
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
nvm install node
nvm install-latest-npm
npm install pm2 -g
cd -
cd ..
cd app_marks 
npm install 

#запуск приложения
pm2 start -f --name app ./index.js 
pm2 save


