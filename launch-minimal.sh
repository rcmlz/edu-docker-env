#!/bin/bash

#macOS specific command to start Docker if it's not already running
open --background -a Docker

sleep 3
docker info

docker compose -f docker-compose-minimal.yml up

docker compose -f docker-compose-minimal.yml down --remove-orphans
