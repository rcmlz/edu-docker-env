# edu-docker-env

## Pull

```bash
docker pull rcmlz/edu-jupyter-minimal
```

```bash
docker pull rcmlz/edu-jupyter-full
```

## Get Source and Start

```bash
git clone --depth 1 https://github.com/rcmlz/edu-docker-env
cd edu-docker-env
```

```bash
docker compose -f compose/docker-compose-rcmlz-edu-jupyter-minimal.yml up --remove-orphans
```

```bash
docker compose -f compose/docker-compose-rcmlz-edu-jupyter-full.yml up --remove-orphans
```

## Build and Launch Yourself

```bash
cd build

export DOCKER_BUILDKIT=1
docker buildx create --use
docker buildx inspect --bootstrap
```

```bash
./build-jupyter-minimal.sh
./build-jupyter-full.sh
```

## Export / Import

### Mac
```bash
docker save --platform=linux/arm64 rcmlz/edu-jupyter-full:latest | gzip > edu-jupyter-full-arm64.tar.gz
docker save --platform=linux/arm64 rcmlz/edu-jupyter-minimal:latest | gzip > edu-jupyter-minimal-arm64.tar.gz
docker save --platform=linux/arm64 rcmlz/edu-jupyter-tiny:latest | gzip > edu-jupyter-tiny-arm64.tar.gz
ls -lh
```

### Linux
```bash
docker save --platform=linux/amd64 rcmlz/edu-jupyter-full:latest | gzip > edu-jupyter-full-amd64.tar.gz
docker save --platform=linux/amd64 rcmlz/edu-jupyter-minimal:latest | gzip > edu-jupyter-minimal-amd64.tar.gz
docker save --platform=linux/amd64 rcmlz/edu-jupyter-tiny:latest | gzip > edu-jupyter-tiny-amd64.tar.gz
ls -lh
```

## Import

### Mac
```bash
cd /Volumes/Ventoy
ls -lh
docker load --platform=linux/arm64 --input edu-jupyter-full-arm64.tar.gz
docker save --platform=linux/arm64 --input edu-jupyter-minimal-arm64.tar.gz
docker save --platform=linux/arm64 --input edu-jupyter-tiny-arm64.tar.gz
```

### Linux
```bash
cd /media/run/$USER/Ventoy
ls -lh
docker load --platform=linux/amd64 --input edu-jupyter-full-amd64.tar.gz
docker load --platform=linux/amd64 --input edu-jupyter-minimal-amd64.tar.gz
docker load --platform=linux/amd64 --input edu-jupyter-tiny-amd64.tar.gz
```

### Windows
```bash
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
```
