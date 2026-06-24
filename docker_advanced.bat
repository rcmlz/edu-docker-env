@echo off
setlocal enabledelayedexpansion

set DOCKER_COMPOSE_FILE=%userprofile%\Downloads\%DOCKER_COMPOSE_FILE_NAME%
set DOCKER_COMPOSE_FILE_URL=https://raw.githubusercontent.com/rcmlz/edu-docker-env/refs/heads/main/compose/%DOCKER_COMPOSE_FILE_NAME%
set HOME=%USERPROFILE%

echo.
echo Mapping local folder %USERPROFILE%\jupyter to the folder named work in the container.
mkdir "%HOME%\jupyter" 2>nul
echo.

REM download docker-compose file when online, otherwise keep existing file
set TMP_FILE=%DOCKER_COMPOSE_FILE%.tmp
curl -f -o "%TMP_FILE%" "%DOCKER_COMPOSE_FILE_URL%"
if not errorlevel 1 (
    del "%DOCKER_COMPOSE_FILE%" 2>nul
    move /Y "%TMP_FILE%" "%DOCKER_COMPOSE_FILE%" >nul
) else (
    echo Download failed, keeping existing file.
    del "%TMP_FILE%" 2>nul
)

docker compose -f %DOCKER_COMPOSE_FILE% up --remove-orphans &

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
