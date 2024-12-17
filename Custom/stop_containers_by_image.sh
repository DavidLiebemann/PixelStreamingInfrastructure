#!/bin/bash

# Image name as argument
if [ -z "$1" ]; then
    echo "Usage: $0 <Image-Name>"
    exit 1
fi

IMAGE_NAME=$1

# Alle Container des Images stoppen
CONTAINERS=$(docker ps -q --filter ancestor=$IMAGE_NAME)

if [ -z "$CONTAINERS" ]; then
    echo "Found no running containers for image '$IMAGE_NAME'."
else
    echo "stopping container of image '$IMAGE_NAME'..."
    docker stop $CONTAINERS
    echo "All containers stopped."
fi
