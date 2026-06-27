#!/bin/env bash
cd /run/media/$USER/Ventoy
ls -lh
docker load --platform=linux/arm64 --input edu-jupyter-full-arm64.tar.gz
docker load --platform=linux/arm64 --input edu-jupyter-minimal-arm64.tar.gz
docker load --platform=linux/arm64 --input edu-jupyter-tiny-arm64.tar.gz
