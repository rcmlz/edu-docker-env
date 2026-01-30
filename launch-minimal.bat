@echo off
REM ================================
REM Start Docker Desktop (Windows)
REM ================================

REM Start Docker Desktop in the background
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"

REM Wait a few seconds for Docker to initialize
timeout /t 3 /nobreak > nul

REM Check Docker status
docker info

REM ================================
REM Run Docker Compose
REM ================================

docker compose -f docker-compose-minimal.yml up

REM ================================
REM Shutdown & cleanup
REM ================================

docker compose -f docker-compose-minimal.yml down --remove-orphans
