#!/bin/env bash
cd /run/media/$USER/Ventoy
ls -lh
docker load --platform=linux/amd64 --input edu-jupyter-full-amd64.tar.gz
docker load --platform=linux/amd64 --input edu-jupyter-minimal-amd64.tar.gz
docker load --platform=linux/amd64 --input edu-jupyter-tiny-amd64.tar.gz
