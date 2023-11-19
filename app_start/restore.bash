#!/bin/bash
cd app_start || echo 'Вы в каталоге app_start'
cd ..
cp -r $1 app_marks
sudo -u postgres psql -d postgres --file=$2
