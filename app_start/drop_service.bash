#!/bin/bash

source start.bash

cd $(dirname $0) || error_exit '';
cd ..
sudo rm -rf app_marks || error_exit 'Проект с сервисом не найден'
sudo -u postgres psql -c 'DROP DATABASE appmarks' || error_exit 'База данных не найдена';  