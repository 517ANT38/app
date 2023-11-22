#!/bin/bash
cd $(dirname $0);
cd ..
sudo rm -rf app_marks
sudo -u postgres psql -c 'DROP DATABASE appmarks'; 