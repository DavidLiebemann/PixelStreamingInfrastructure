# Use the current Long Term Support (LTS) version of Node.js
FROM node:lts

# Copy the Matchmaker Server-Code
COPY /Matchmaker /Matchmaker

# Install the dependencies for the signalling server and build the frontend
RUN Matchmaker/platform_scripts/bash/setup.sh --build

# Expose TCP ports 80 and 443 for player WebSocket connections and web server HTTP(S) access
EXPOSE 80
EXPOSE 443

# Expose port 9999for communication with the signalling server
EXPOSE 9999

# Set the matchmaker server as the container's entrypoint
ENTRYPOINT ["/usr/local/bin/node", "/Matchmaker/matchmaker.js"]
