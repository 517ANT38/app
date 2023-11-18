#!/bin/bash

for((i=0;i<$1;i++))
do 
    r0=$(curl --ipv4 --location 'http://localhost:8080/api/objectSights/new' \
    --header 'Content-Type: application/json' \
    --data "{
        \"name\":\"Space $i\",
        \"description\":\"Lorem ipsum dolor s $i$i\",
        \"address\":{\"address\":\"Hello Hello\",\"x\":$i,\"y\":$i}

        }");
    id_obj=$(echo $r0 | jq -r '.id');

    r1=$(curl --ipv4 --location 'http://localhost:8080/api/questions/new' \
    --header 'Content-Type: application/json' \
    --data "{
        \"text\":\"Lorem ipsum dolor sit, amet consectetur adipisicing elit. Quis aspernatur earum dolor distinctio explicabo, suscipit adipisci corrupti iusto facere libero voluptatibus. Officia magni corrupti explicabo placeat quae, voluptatem necessitatibus id.\",
        \"ObjectSightId\":$id_obj
    }");
   

    id_q=$(echo $r1 | jq -r '.id');

    r2=$(curl --ipv4 --location 'http://localhost:8080/api/users/new' \
    --header 'Content-Type: application/json' \
    --data "{
        \"name\":\"Username $i\"
    }");

    
    id_u=$(echo $r2 | jq -r '.id');

    curl --ipv4 --location 'http://localhost:8080/api/answers/new' \
    --header 'Content-Type: application/json' \
    --data "{
        \"UserId\":$id_u,
        \"QuestionId\":$id_q,
        \"stateAnswer\":true
    }" > /dev/null

done