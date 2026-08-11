#!/usr/bin/env bash

DOCKER_COMPOSE_FILE_NAME=docker-compose-hedgedoc.yml
URL=http://localhost:3000

CURRENT_PATH=`dirname -- "$( readlink -f -- "$0"; )"`

source $CURRENT_PATH/bin/docker_advanced.sh
