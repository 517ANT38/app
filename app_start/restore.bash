#!/bin/bash
cp -r $1 app_marks
sudo -u postgres psql --file=app_start/create_database.sql
sudo -u postgres psql -d appmarks --file=$2
