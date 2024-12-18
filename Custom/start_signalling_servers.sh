#!/bin/bash

# docker image name
IMAGE_NAME="pixelstreaming-signallingwebserver5.3"

# Start Ports
MATCHMAKER_PORT=9999
BASE_HTTP_PORT=81
BASE_HTTPS_PORT=8443
BASE_STREAMER_PORT=8888
BASE_SFU_PORT=9000

# default number of servers, if no argument given
DEFAULT_NUM_SERVERS=4

# number of servers
NUM_SERVERS=${1:-$DEFAULT_NUM_SERVERS}


# Determine Server-IP
SERVER_IP=$(hostname -I | awk '{print $1}')

# Name of stop and remove script
STOP_SCRIPT="stop_and_remove_containers_by_image.sh"

# Prüfen, ob das andere Skript existiert
if [ -f "$STOP_SCRIPT" ]; then
    echo "Calling stop and remove script..."
    bash "$STOP_SCRIPT"
else
    echo "Stop script $STOP_SCRIPT not found. Skipping stopping and removing already running signalling servers."
fi


echo "Starting $NUM_SERVERS Signalling Servers..."

# starting given number of signalling servers
for (( i=0; i<$NUM_SERVERS; i++ )); do
    SIGNAL_PORT=$(( BASE_HTTP_PORT + i ))      # Signal-Port: 81, 82, 83, ...
    STREAMER_PORT=$(( BASE_STREAMER_PORT + i ))  # Streamer-Port: 8888, 8889, ...
    SFU_PORT=$(( BASE_SFU_PORT + i ))            # SFU-Port: 9000, 9001, ...
    CONTAINER_NAME="signalling_server_$(( i + 1 ))"

    echo "Starting Signalling Server $(( i + 1 ))..."
    echo " - Signal-Port: $SIGNAL_PORT"
    echo " - Streamer-Port: $STREAMER_PORT"
    echo " - SFU-Port: $SFU_PORT"

    docker run -d \
        --name $CONTAINER_NAME \
        -p $SIGNAL_PORT:$SIGNAL_PORT \
        -p $STREAMER_PORT:8888 \
        -p $SFU_PORT:8889 \
        $IMAGE_NAME \
        --UseMatchmaker \
        --MatchmakerAddress $SERVER_IP \
        --MatchmakerPort $MATCHMAKER_PORT \
        --HttpPort $SIGNAL_PORT \
        --PublicIp $SERVER_IP \
    
    echo "Signalling Server $(( i + 1 )) started:"
    echo " - Signalling Server: http://$SERVER_IP:$SIGNAL_PORT"
    echo "---------------------------------------------"
done

echo "All $NUM_SERVERS Signalling Server have been started!"
