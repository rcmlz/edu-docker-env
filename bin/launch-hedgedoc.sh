#!/bin/bash

DOCKER_COMPOSE_FILE=compose/docker-compose-hedgedoc.yml
URL="http://localhost:3000"

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

# Cleanup function
cleanup() {
    echo ""
    echo "Stopping docker compose..."
    docker compose -f "$DOCKER_COMPOSE_FILE" down --remove-orphans
    echo "Done."
}

# Run cleanup on script exit (including Ctrl+C, terminal close, etc.)
trap cleanup EXIT INT TERM

docker compose -f $DOCKER_COMPOSE_FILE up --remove-orphans &

until docker compose -f "$DOCKER_COMPOSE_FILE" ps | grep -q "Up"; do
    sleep 1
    echo "waiting for Container to start..."
done

echo ""
echo "Open $URL in your browser to access HedgeDoc."
echo ""

# wait until the jupyter notebook is reachable
until curl -fsS "$URL" >/dev/null 2>&1; do
    sleep 1
    echo "waiting for HedgeDoc to start..."
done

open $URL || xdg-open $URL || sensible-browser $URL || x-www-browser $URL || gnome-open $URL

# Keep script running so trap works when shell is closed
wait