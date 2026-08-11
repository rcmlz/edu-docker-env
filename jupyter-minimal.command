#!/usr/bin/env bash

DOCKER_COMPOSE_FILE_NAME=docker-compose-rcmlz-edu-jupyter-minimal.yml
URL=http://localhost:8888?token=go

CURRENT_PATH=`dirname -- "$( readlink -f -- "$0"; )"`

source $CURRENT_PATH/bin/docker_advanced.sh
