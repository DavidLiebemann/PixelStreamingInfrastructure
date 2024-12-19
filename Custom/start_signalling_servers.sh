#!/bin/bash


# ------------ STUN AND TURN SETUP ------------
# load TURN- and STUN Config Scripts
source ../SignallingWebServer/platform_scripts/bash/common_utils.sh
source ../SignallingWebServer/platform_scripts/bash/turn_user_pwd.sh

# default values for STUN- and TURN-Server 
set_start_default_values "y" "y" # activate STUN and TURN

PEER_CONNECTION_OPTIONS="{\""iceServers\"":[{\""urls\"":[\""stun:${stunserver}\"",\""turn:${turnserver}\""],\""username\"":\""${turnusername}\"",\""credential\"":\""${turnpassword}\""}]}"

# ------------ STUN AND TURN END ------------

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
    HTTP_PORT=$(( BASE_HTTP_PORT + i ))      # Http-Port: 81, 82, 83, ...
    HTTPS_PORT=$(( BASE_HTTPS_PORT + i ))      # Https-Port: 8443, 8444, 8445, ...
    STREAMER_PORT=$(( BASE_STREAMER_PORT + i * 2 ))  # Host-Streamer-Port: 8888, 8890, 8892, ...
    SFU_PORT=$(( STREAMER_PORT + 1 ))         # Host-SFU-Port: 8889, 8891, 8893, ...
    CONTAINER_NAME="signalling_server_$(( i + 1 ))"

    echo "Starting Signalling Server $(( i + 1 ))..."
    echo " - Signal-Port: $HTTP_PORT"
    echo " - Streamer-Port: $STREAMER_PORT"
    echo " - SFU-Port: $SFU_PORT"

    docker run -d \
        --name $CONTAINER_NAME \
        -p $HTTP_PORT:$HTTP_PORT \
        -p $HTTPS_PORT:$HTTPS_PORT \
        -p $STREAMER_PORT:8888 \
        -p $SFU_PORT:8889 \
        $IMAGE_NAME \
        --UseMatchmaker \
        --MatchmakerAddress $SERVER_IP \
        --MatchmakerPort $MATCHMAKER_PORT \
        --HttpPort $HTTP_PORT \
        --HttpsPort $HTTPS_PORT \
        --UseHttps \
        --PublicIp $SERVER_IP \
        --peerConnectionOptions "'${PEER_CONNECTION_OPTIONS}'" \
    
    echo "Signalling Server $(( i + 1 )) started:"
    echo " - Signalling Server: https://$SERVER_IP:$HTTPS_PORT"
    echo "---------------------------------------------"
done

echo "All $NUM_SERVERS Signalling Server have been started!"
