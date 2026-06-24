#!/usr/bin/env bash

# check if DOCKER_COMPOSE_FILE_NAME and URL are defined
if [[ -z "${DOCKER_COMPOSE_FILE_NAME+x}" ]]; then
    echo "ERROR: DOCKER_COMPOSE_FILE_NAME is not defined"
    exit 1
fi

if [[ -z "${URL+x}" ]]; then
    echo "ERROR: URL is not defined."
    exit 1
fi

# check if docker is running
if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Docker not running."
    exit 1
fi

DOCKER_COMPOSE_FILE="$HOME/Downloads/$DOCKER_COMPOSE_FILE_NAME"
DOCKER_COMPOSE_FILE_URL="https://raw.githubusercontent.com/rcmlz/edu-docker-env/refs/heads/main/compose/$DOCKER_COMPOSE_FILE_NAME"

echo -e "Mapping local folder $HOME/jupyter in the container."
mkdir -p "$HOME/jupyter"
echo ""

# Cleanup function
cleanup() {
    echo ""
    echo "Stopping docker compose..."
    docker compose -f "$DOCKER_COMPOSE_FILE" down --remove-orphans
    echo "Done."
}

# Run cleanup on script exit (including Ctrl+C, terminal close, etc.)
trap cleanup EXIT INT TERM

# Download docker-compose file
if curl -fsS "$URL" >/dev/null 2>&1; then
    rm -f "$DOCKER_COMPOSE_FILE"
fi
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

# Keep script running so trap works when shell is closed
wait