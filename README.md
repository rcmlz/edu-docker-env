# edu-docker-env

## Pull via Network

```bash
docker pull rcmlz/edu-jupyter-tiny
```

```bash
docker pull rcmlz/edu-jupyter-minimal
```

```bash
docker pull rcmlz/edu-jupyter-full
```

## Get source and start local

```bash
git clone --depth 1 https://github.com/rcmlz/edu-docker-env
cd edu-docker-env
```

```bash
docker compose -f compose/docker-compose-rcmlz-edu-jupyter-tiny.yml up --remove-orphans
```

```bash
docker compose -f compose/docker-compose-rcmlz-edu-jupyter-minimal.yml up --remove-orphans
```

```bash
docker compose -f compose/docker-compose-rcmlz-edu-jupyter-full.yml up --remove-orphans
```

```bash
docker compose -f compose/docker-compose-hedgedoc up --remove-orphans
```
