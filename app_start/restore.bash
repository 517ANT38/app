#!/bin/bash

source functions_util.bash

cd $(dirname $0) || error_exit '';
cd ..
cp -r $1 app_marks
sudo -u postgres psql -d postgres --file=$2
pm2 restart app
