@echo off
REM ================================
REM Start Docker Desktop (Windows)
REM ================================

REM Start Docker Desktop in the background
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"

REM Wait a few seconds for Docker to initialize
timeout /t 3 /nobreak > nul

docker pull quay.io/jupyter/datascience-notebook
docker pull quay.io/jupyter/minimal-notebook
