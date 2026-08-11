@echo off
setlocal EnableDelayedExpansion

set "VENTOY_DRIVE=unknow"

REM Detect Drive
for /f %%i in ('
    powershell -NoProfile -Command ^
    "(Get-Volume -FileSystemLabel 'Ventoy' | Select-Object -First 1 -ExpandProperty DriveLetter)"
') do (
    set "VENTOY_DRIVE=%%i:"
)

REM Validate detetcted Drive
for %%D in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
  if "%VENTOY_DRIVE%"=="%%D:" (
    echo Ventoy drive found: %VENTOY_DRIVE%
    goto :ventoy_found
  )
)

echo ERROR: Ventoy USB stick %VENTOY_DRIVE% must be any drive D: ... Z:.
pause
exit /b 1

:ventoy_found
cd /d "%VENTOY_DRIVE%"

if /I "%PROCESSOR_ARCHITECTURE%"=="ARM64" (
  set "PA=arm64"
) else (
  set "PA=amd64"
)

REM for %%F in (edu-jupyter-full-%PA%.tar.gz edu-jupyter-minimal-%PA%.tar.gz edu-jupyter-tiny-%PA%.tar.gz) do (
for %%F in (edu-jupyter-minimal-%PA%.tar.gz edu-jupyter-tiny-%PA%.tar.gz) do (
  echo docker load --platform=linux/%PA% --input %%F
  docker load --platform=linux/%PA% --input %%F
)
