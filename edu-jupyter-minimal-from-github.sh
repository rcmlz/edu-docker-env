#!/usr/bin/env bash

DOCKER_COMPOSE_FILE_NAME="docker-compose-rcmlz-edu-jupyter-minimal.yml"
DOCKER_COMPOSE_FILE="$HOME/Downloads/$DOCKER_COMPOSE_FILE_NAME"
DOCKER_COMPOSE_FILE_URL="https://raw.githubusercontent.com/rcmlz/edu-docker-env/refs/heads/main/compose/$DOCKER_COMPOSE_FILE_NAME"
URL="http://localhost:8888?token=go"

echo -e "Mapping local folder $HOME/jupyter in the container."
mkdir -p "$HOME/jupyter"
echo ""

# Download docker-compose file
curl -f -o "$DOCKER_COMPOSE_FILE" "$DOCKER_COMPOSE_FILE_URL"

# Start docker compose in background
docker compose -f "$DOCKER_COMPOSE_FILE" up --remove-orphans &

# Wait until container is "Up"
echo "Waiting for container to start..."
while true; do
    if docker compose -f "$DOCKER_COMPOSE_FILE" ps | grep -q "Up"; then
        break
    fi
    sleep 1
done

echo
echo "Open $URL in your browser to access Jupyter."
echo

# Wait until service is reachable
echo "Waiting for Jupyter to start..."
while true; do
    if curl -fsS "$URL" >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

# Open browser (macOS)
open "$URL"
