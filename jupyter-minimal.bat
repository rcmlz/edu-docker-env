@echo off

set DOCKER_COMPOSE_FILE_NAME=docker-compose-rcmlz-edu-jupyter-minimal.yml
set URL=http://localhost:8888?token=go

call docker_simple.bat
