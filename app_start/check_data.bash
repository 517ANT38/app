#!/bin/bash

ls -R app_marks/ | more
echo "---------------------------------------------------------------------------"
echo 'Users:'
curl --ipv4 --location 'http://localhost:4567/api/users' | jq . | more
echo 'Object sights:'
curl --ipv4 --location 'http://localhost:4567/api/objectSights' | jq . | more
echo 'Questions:'
curl --ipv4 --location 'http://localhost:4567/api/questions' | jq . | more
echo 'Answers:'
curl --ipv4 --location 'http://localhost:4567/api/answers/' | jq . | more