#!/bin/bash
sudo rm -rf app_marks
sudo -u postgres psql -c 'DROP DATABASE appmarks'; 