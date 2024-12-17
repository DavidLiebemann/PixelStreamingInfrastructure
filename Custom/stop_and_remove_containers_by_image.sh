#!/bin/bash

# Image-Name als Argument
if [ -z "$1" ]; then
    echo "Usage: $0 <Image-Name>"
    exit 1
fi

IMAGE_NAME=$1

# Alle Container des Images stoppen und entfernen
CONTAINERS=$(docker ps -aq --filter ancestor=$IMAGE_NAME)

if [ -z "$CONTAINERS" ]; then
    echo "Did not find any containers for image '$IMAGE_NAME'."
else
    echo "stopping and removing containers for image '$IMAGE_NAME'..."
    docker stop $CONTAINERS
    docker rm $CONTAINERS
    echo "all containers stopped and removed."
fi
