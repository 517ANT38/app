#!/bin/bash
sudo mkdir -p /backups
sudo chown $USER:$USER /backups 
chmod 0777 /backups
rsync -aAXv app_marks /backups/
sudo su postgres
pg_dump -d appmarks > /backups/appmarks.dmp
exit