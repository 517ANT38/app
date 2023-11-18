#!/bin/bash

ls -R app_marks/ | more
echo "---------------------------------------------------------------------------"
echo 'Users:'
curl --ipv4 --location 'http://localhost:8080/api/users' | jq . | more
echo 'Object sights:'
curl --ipv4 --location 'http://localhost:8080/api/objectSights' | jq . | more
echo 'Questions:'
curl --ipv4 --location 'http://localhost:8080/api/questions' | jq . | more
echo 'Answers:'
curl --ipv4 --location 'http://localhost:8080/api/answers/' | jq . | more