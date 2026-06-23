#!/bin/bash

DOCKER_COMPOSE_FILE=compose/docker-compose-rcmlz-edu-jupyter-minimal.yml
URL="http://localhost:8888?token=go"

echo -e "Mapping local folder $HOME/jupyter in the container."
mkdir -p "$HOME/jupyter"
echo ""

# start docker if it's not already running
#if docker info >/dev/null 2>&1; then
#    echo "Docker already running."
#else
#    case "$OSTYPE" in
#      linux-gnu*) sudo systemctl start docker ;;
#      darwin*)    open --background -a Docker ;;
#    esac
#    # wait for docker to be ready
#    until docker info >/dev/null 2>&1; do
#                echo "waiting for docker to start..."
#                sleep 1
#    done
#fi

docker compose -f $DOCKER_COMPOSE_FILE up --remove-orphans &

until docker compose -f "$DOCKER_COMPOSE_FILE" ps | grep -q "Up"; do
    sleep 1
    echo "waiting for Container to start..."
done

# wait until the jupyter notebook is reachable
until curl -fsS "$URL" >/dev/null 2>&1; do
    sleep 1
    echo "waiting for Jupyter Notebook to start..."
done

echo ""
echo "Open $URL in your browser to access Jupyter Notebook."
echo ""

open $URL || xdg-open $URL || sensible-browser $URL || x-www-browser $URL || gnome-open $URL
