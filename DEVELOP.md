
## Build and Launch Yourself

```bash
cd build

export DOCKER_BUILDKIT=1
docker buildx create --use
docker buildx inspect --bootstrap
```

```bash
./build-jupyter-tiny.sh
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
