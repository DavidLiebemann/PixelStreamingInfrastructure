#!/bin/bash


HTTP_PORT_MAPPING="80:80"
HTTPS_PORT_MAPPING="443:443"
MATCHMAKER_PORT_MAPPING="9999:9999"

CONTAINER_NAME="matchmaking-server"
IMAGE_NAME="pixelstreaming-matchmaker5.3"


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
docker run -d --name $CONTAINER_NAME -p $MATCHMAKER_PORT_MAPPING -p $HTTP_PORT_MAPPING -p $HTTPS_PORT_MAPPING $IMAGE_NAME
echo "Matchmaker server was started."
