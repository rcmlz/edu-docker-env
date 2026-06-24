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

REM Open browser
start "" "%URL%"

docker compose -f %DOCKER_COMPOSE_FILE% up --remove-orphans

endlocal
