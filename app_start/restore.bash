#!/bin/bash
cp -r $1 app_marks
sudo -u postgres psql -c 'CREATE DATABASE appmarks' || echo 'БД appmarks уже существует';
sudo -u postgres psql -d appmarks --file=$2
