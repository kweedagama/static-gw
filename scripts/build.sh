#!/usr/bin/env bash

source ./common.sh

CONTAINER_ID=$(get_running_container)

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -v | --version )
    echo $VERSION
    exit
    ;;
  -k | --kill )
    stop_container $CONTAINER_ID
    remove_container $CONTAINER_ID
    ;;
  -s | --start )
    start_service $CODE_DIR $CONTAINER_NAME
    ;;
  -d | --start-dev )
    FLAGS="-v $CODE_DIR/nginx/conf.d:/etc/nginx/conf.d"
    start_service $CODE_DIR $CONTAINER_NAME
    ;;
  -c | --container)
    get_running_container
    ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi


