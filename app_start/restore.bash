#!/bin/bash
cd $(dirname $0);
cd ..
cp -r $1 app_marks
sudo -u postgres psql -d postgres --file=$2
