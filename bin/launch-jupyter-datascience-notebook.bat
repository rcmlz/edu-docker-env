@echo off
setlocal enabledelayedexpansion

set DOCKER_COMPOSE_FILE=..\compose\docker-compose-jupyter-datascience-notebook.yml
set URL="http://localhost:8888?token=go"
set HOME=%USERPROFILE%

echo.
echo Mapping local folder %USERPROFILE%\jupyter to the folder named work in the container.
mkdir "%HOME%\jupyter" 2>nul
echo.

REM Check if Docker is running
REM docker info >nul 2>&1
REM if %errorlevel%==0 (
REM     echo Docker already running.
REM ) else (
REM     echo Starting Docker Desktop...
REM    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"

REM Wait for Docker to be ready
REM    :wait_docker
REM    docker info >nul 2>&1
REM    if not %errorlevel%==0 (
REM        timeout /t 1 >nul
REM        echo "waiting for docker to start..."
REM        goto wait_docker
REM    )
REM )

REM Start docker compose in background
start "" docker compose -f "%DOCKER_COMPOSE_FILE%" up --remove-orphans

REM Wait until container is "Up"
:wait_container
docker compose -f "%DOCKER_COMPOSE_FILE%" ps | findstr /C:"Up" >nul
if errorlevel 1 (
    timeout /t 1 >nul
    echo "waiting for Container to start..."
    goto wait_container
)

echo.
echo Open %URL% in your browser to access Jupyter.
echo.

REM Wait until service is reachable
:wait_http
curl -fsS "%URL%" >nul 2>&1
if errorlevel 1 (
    timeout /t 1 >nul
    echo "waiting for Jupyter to start..."
    goto wait_http
)

REM Open browser
start "" "%URL%"

endlocal
