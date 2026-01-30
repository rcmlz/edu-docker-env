#!/bin/bash

#macOS specific command to start Docker if it's not already running
open --background -a Docker

#windows
#start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
#docker desktop start

#linux
#systemctl --user start docker

sleep 3
docker info

#docker pull quay.io/jupyter/datascience-notebook
#docker pull quay.io/jupyter/minimal-notebook

#export DOCKER_BUILDKIT=1
docker build -t rcmlz/edu-docker-env-minimal:latest -f Dockerfile-minimal .

docker compose -f docker-compose-minimal.yml up

docker compose -f docker-compose-minimal.yml down --remove-orphans
