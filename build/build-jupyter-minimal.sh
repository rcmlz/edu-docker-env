#!/bin/bash

#docker info

export DOCKER_BUILDKIT=1
#docker buildx create --use
#docker buildx inspect --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 -t rcmlz/edu-jupyter-minimal:latest -f Dockerfile-edu-jupyter-minimal --push .
