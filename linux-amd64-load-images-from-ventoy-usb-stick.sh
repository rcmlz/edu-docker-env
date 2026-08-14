#!/bin/env bash
cd /run/media/$USER/Ventoy
ls -lh

for image in edu-jupyter-{full,minimal,tiny}-arm64.tar.gz; do
    echo ""
    echo importing docker image from Ventoy USB stick: "$image"
    echo ""
    echo docker load --platform=linux/arm64 --input "$image"
    docker load --platform=linux/arm64 --input "$image"
done