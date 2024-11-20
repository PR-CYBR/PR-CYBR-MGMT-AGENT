#!/bin/bash

# Update system
echo "Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

# Install necessary software
echo "Installing Docker, Docker Compose, and ZeroTier..."
sudo apt-get install -y docker.io docker-compose tmux
curl -s https://install.zerotier.com | sudo bash

# Pull latest version of containers
echo "Pulling latest Docker images..."
docker-compose pull

# Setup Container Network
echo "Setting up Docker network..."
docker network create pr_cybr_mgmt_agent_network || true

# Ensure Containers are connected to network / have access
echo "Starting Docker containers..."
docker-compose up -d

# Ensure PostgreSQL container is functional
echo "Checking PostgreSQL container status..."
until docker exec pr-cybr-agent-db pg_isready -U $POSTGRES_USER; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

# Start `server.js`
echo "Starting server.js..."
tmux new-session -d -s server-setup "node src/js/server.js"

# Ensure Zerotier is installed and configured
echo "Configuring ZeroTier..."
read -p "Enter ZeroTier Network ID: " ZT_NETWORK_ID
sudo zerotier-cli join $ZT_NETWORK_ID

read -p "Enter desired ZeroTier IP Address: " ZT_IP_ADDRESS
sudo zerotier-cli set $ZT_NETWORK_ID ip4assignments $ZT_IP_ADDRESS

# Create a new tmux session with separate window panes
echo "Setting up tmux session..."
tmux new-session -d -s server-monitor
tmux split-window -h
tmux send-keys -t server-monitor:0.0 "node src/js/server.js" C-m
tmux send-keys -t server-monitor:0.1 "tail -f server.log" C-m

echo "Server setup complete. Use 'tmux attach -t server-monitor' to view the session."