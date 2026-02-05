echo off
REM set DOCKER_COMPOSE_FILE_NAME=docker-compose-full.yml
set DOCKER_COMPOSE_FILE_NAME=docker-compose-minimal.yml

set HOME=%userprofile%
set DOCKER_COMPOSE_FILE=%userprofile%\Downloads\%DOCKER_COMPOSE_FILE_NAME%
set DOCKER_COMPOSE_FILE_URL=https://raw.githubusercontent.com/rcmlz/edu-docker-env/refs/heads/main/%DOCKER_COMPOSE_FILE_NAME%

curl -o %DOCKER_COMPOSE_FILE% %DOCKER_COMPOSE_FILE_URL%

docker compose -f %DOCKER_COMPOSE_FILE% up

pause
