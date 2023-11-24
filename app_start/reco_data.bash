#!/bin/bash

source functions_util.bash

cd $(dirname $0) || error_exit '';
sudo mkdir -p /backups
sudo chown $USER:$USER /backups 
chmod 0777 /backups
cd ..



# Название процесса, который нужно проверить
process_name="app"

# Получаем вывод команды 'pm2 show' для процесса
output=$(pm2 show "$process_name" 2>&1)

# Используем awk для проверки статуса процесса
is_running=$(echo "$output" | awk '/status/{print $4}')

# Проверяем статус процесса и выводим соответствующее сообщение
if [[ "$is_running" == "online" ]]; then
    error_exit "Процесс запущен."
    
else
   rsync -aAXv app_marks /backups/ || error_exit  'Проект с сервисом не найден';
   sudo -u postgres pg_dump -C -d appmarks > /backups/appmarks.dmp || error_exit 'База данных не найдена'; 
fi




