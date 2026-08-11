#!/bin/bash

#docker info

export DOCKER_BUILDKIT=1
#docker buildx create --use
#docker buildx inspect --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 -t rcmlz/edu-jupyter-minimal:latest -f Dockerfile-edu-jupyter-minimal --push .

docker save rcmlz/edu-jupyter-minimal:latest --platform linux/amd64 | gzip > $HOME/Downloads/edu-jupyter-minimal-amd64.tar.gz
docker save rcmlz/edu-jupyter-minimal:latest --platform linux/arm64 | gzip > $HOME/Downloads/edu-jupyter-minimal-arm64.tar.gz
