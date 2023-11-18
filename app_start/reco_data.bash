#!/bin/bash
cd app_start || echo 'Вы в каталоге app_start'
sudo mkdir -p /backups
sudo chown $USER:$USER /backups 
chmod 0777 /backups
cd ..
rsync -aAXv app_marks /backups/
sudo -u postgres pg_dump -d appmarks > /backups/appmarks.dmp
