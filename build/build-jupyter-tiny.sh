#!/bin/bash

#docker info

export DOCKER_BUILDKIT=1
#docker buildx create --use
#docker buildx inspect --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 -t rcmlz/edu-jupyter-tiny:latest -f Dockerfile-edu-jupyter-tiny --push .

docker save rcmlz/edu-jupyter-tiny:latest --platform linux/amd64 | gzip > $HOME/Downloads/edu-jupyter-tiny-amd64.tar.gz
docker save rcmlz/edu-jupyter-tiny:latest --platform linux/arm64 | gzip > $HOME/Downloads/edu-jupyter-tiny-arm64.tar.gz
