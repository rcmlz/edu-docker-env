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

docker pull quay.io/jupyter/datascience-notebook

export DOCKER_BUILDKIT=1
docker buildx create --use
docker buildx inspect --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 -t rcmlz/edu-jupyter-full:latest -f Dockerfile-jupyter-full --push .
