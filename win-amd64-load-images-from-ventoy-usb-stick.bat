@echo off
setlocal

set "VENTOY_DRIVE="

for /f %%i in ('
    powershell -NoProfile -Command ^
    "(Get-Volume -FileSystemLabel 'Ventoy' | Select-Object -First 1 -ExpandProperty DriveLetter)"
') do (
    set "VENTOY_DRIVE=%%i:"
)

echo Ventoy drive found: %VENTOY_DRIVE%
%VENTOY_DRIVE%
dir

docker load --platform=linux/amd64 --input edu-jupyter-full-amd64.tar.gz
docker load --platform=linux/amd64 --input edu-jupyter-minimal-amd64.tar.gz
docker load --platform=linux/amd64 --input edu-jupyter-tiny-amd64.tar.gz