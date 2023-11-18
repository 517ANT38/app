#!/bin/bash
sudo rm -rf app_marks
sudo su postgres
psql -c "DROP DATABASE IF EXISTS appmarks"
exit