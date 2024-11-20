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

# Set up GitHub self-hosted runner
echo "Setting up GitHub self-hosted runner..."
RUNNER_VERSION="2.308.0" # Update to the latest version as needed
RUNNER_DIR="actions-runner"

# Create runner directory
mkdir -p $RUNNER_DIR && cd $RUNNER_DIR

# Download and extract the runner
curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Configure the runner
echo "Enter your GitHub repository URL (e.g., https://github.com/owner/repo):"
read REPO_URL
echo "Enter your GitHub runner token:"
read RUNNER_TOKEN

./config.sh --url $REPO_URL --token $RUNNER_TOKEN --unattended --replace

# Install and start the runner service
sudo ./svc.sh install
sudo ./svc.sh start

cd ..

# Create a new tmux session with separate window panes
echo "Setting up tmux session..."
tmux new-session -d -s server-monitor
tmux split-window -h
tmux send-keys -t server-monitor:0.0 "node src/js/server.js" C-m
tmux send-keys -t server-monitor:0.1 "tail -f server.log" C-m

echo "Server setup complete. Use 'tmux attach -t server-monitor' to view the session."