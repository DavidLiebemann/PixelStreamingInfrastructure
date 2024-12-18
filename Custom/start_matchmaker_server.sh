#!/bin/bash

CONTAINER_NAME="matchmaking-server"

# Check if container is already running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Container $CONTAINER_NAME is already running, stopping it"
    docker stop $CONTAINER_NAME
fi

# check if the container already exists, but stopped
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Removing old Container $CONTAINER_NAME..."
    docker rm -f $CONTAINER_NAME
fi

echo "Starting new matchmaker server in background..."
docker run -d --name $CONTAINER_NAME -p $PORT_MAPPING $IMAGE_NAME
echo "Matchmaker server was started."
