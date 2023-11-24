#!/bin/bash
source functions_util.bash
pm2 stop app || error_exit 'Сервис не запущен'