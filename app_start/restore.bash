#!/bin/bash
cp -r $1 app_marks
sudo su postgres
psql --file=app_start/create_database.sql
sudo su postgres
psql -d appmarks --file=$2
exit