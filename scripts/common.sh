#!/usr/bin/env bash

CODE_DIR=/Users/kevinweedagama/code/kevinweedagamaio/gateway
CONTAINER_NAME=web
VERSION=0.1
FLAGS=

get_running_container() {
    container_id=$(docker ps -aqf "name=$CONTAINER_NAME")
    echo $container_id
}

nginx_health() {
    curl http://localhost:8000/health
}

nginx_enter() {
    docker exec -it $(get_running_container) /bin/bash
}

nginx_reload() {
    docker exec $CONTAINER_NAME sh -c "nginx -s reload"
}

nginx_status() {
    docker exec $CONTAINER_NAME sh -c "ps -ax | grep nginx"
}

remove_container() {
    docker rm $1
}

start_service() {
    container_id=$(get_running_container)
    if [[ -n contianer_id ]]; then
        stop_container $container_id
        remove_container $container_id
    fi
    docker build -t kevinweedagamaio $1
    docker run -d -v $CODE_DIR/nginx/conf.d:/etc/nginx/conf.d \
    -v $CODE_DIR/nginx/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf \
    -v $CODE_DIR/logs:/var/log/nginx/ \
    -v $CODE_DIR/src/lua:/lua \
    -v $HOME/.aws:/.aws \
    -p 8000:80 --name $2 kevinweedagamaio
}

stop_container() {
    docker stop $1
}
