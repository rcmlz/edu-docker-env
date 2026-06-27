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

docker load --platform=linux/arm64 --input edu-jupyter-full-arm64.tar.gz
docker load --platform=linux/arm64 --input edu-jupyter-minimal-arm64.tar.gz
docker load --platform=linux/arm64 --input edu-jupyter-tiny-arm64.tar.gz