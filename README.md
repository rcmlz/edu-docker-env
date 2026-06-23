# edu-docker-env

## Pull

```
docker pull rcmlz/edu-jupyter-minimal
```

```
docker pull rcmlz/edu-jupyter-full
```

## Get Source and Start

```
git clone --depth 1 https://github.com/rcmlz/edu-docker-env
cd edu-docker-env
```

````
docker compose -f compose/docker-compose-rcmlz-edu-jupyter-minimal.yml up --remove-orphans
````

````
docker compose -f compose/docker-compose-rcmlz-edu-jupyter-full.yml up --remove-orphans
````

## Build and Launch Yourself

````
cd build

export DOCKER_BUILDKIT=1
docker buildx create --use
docker buildx inspect --bootstrap
````

````
./build-jupyter-minimal.sh
./build-jupyter-full.sh
````
