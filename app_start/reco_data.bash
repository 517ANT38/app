#!/bin/bash
cd $(dirname $0);
sudo mkdir -p /backups
sudo chown $USER:$USER /backups 
chmod 0777 /backups
cd ..

if [ $(pm2 describe app) ]; then 
    echo 'server oneline';
    exit 1
else
    rsync -aAXv app_marks /backups/ || echo 'Service not found'; exit 1
    sudo -u postgres pg_dump -C -d appmarks > /backups/appmarks.dmp || echo 'Database not found'; exit 1
fi