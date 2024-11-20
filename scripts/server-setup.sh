#!/bin/bash

# Copy .env.example to .env if it doesn't exist
if [ ! -f .env ]; then
  echo "Creating .env file from .env.example..."
  cp .env.example .env
fi

# Load environment variables from .env file
export $(cat .env | xargs)

# Inform the user about manual configuration
echo "You can manually set environment variables in the .env.example file and copy it to .env."

# Prompt for DIV-CODE to name the node
read -p "Enter DIV-CODE for the node: " DIV_CODE
sed -i "s/^DIV-CODE=.*/DIV-CODE=$DIV_CODE/" .env

# Prompt for PostgreSQL user if not set
if [ -z "$DB_USER" ]; then
  read -p "Enter PostgreSQL user: " DB_USER
  sed -i "s/^DB_USER=.*/DB_USER=$DB_USER/" .env
fi

# Prompt for PostgreSQL password if not set
if [ -z "$DB_PASSWORD" ]; then
  read -p "Enter PostgreSQL password: " DB_PASSWORD
  sed -i "s/^DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" .env
fi

# Prompt for ZeroTier Network ID
read -p "Enter ZeroTier Network ID: " ZT_NETWORK_ID
sed -i "s/^ZEROTIER_NETWORK_ID=.*/ZEROTIER_NETWORK_ID=$ZT_NETWORK_ID/" .env

# Prompt for ZeroTier IP Address
read -p "Enter desired ZeroTier IP Address: " ZT_IP_ADDRESS
sed -i "s/^ZEROTIER_IP_ADDRESS=.*/ZEROTIER_IP_ADDRESS=$ZT_IP_ADDRESS/" .env

# Prompt for Discord Webhook URL if not set
if [ -z "$DISCORD_WEBHOOK_URL" ]; then
  read -p "Enter Discord Webhook URL: " DISCORD_WEBHOOK_URL
  sed -i "s|^DISCORD_WEBHOOK_URL=.*|DISCORD_WEBHOOK_URL=$DISCORD_WEBHOOK_URL|" .env
fi

# Prompt for GitHub Token if not set
if [ -z "$GITHUB_TOKEN" ]; then
  read -p "Enter GitHub Token: " GITHUB_TOKEN
  sed -i "s/^GITHUB_TOKEN=.*/GITHUB_TOKEN=$GITHUB_TOKEN/" .env
fi

# Prompt for Repo Owner if not set
if [ -z "$REPO_OWNER" ]; then
  read -p "Enter Repo Owner: " REPO_OWNER
  sed -i "s/^REPO_OWNER=.*/REPO_OWNER=$REPO_OWNER/" .env
fi

# Prompt for Repo Name if not set
if [ -z "$REPO_NAME" ]; then
  read -p "Enter Repo Name: " REPO_NAME
  sed -i "s/^REPO_NAME=.*/REPO_NAME=$REPO_NAME/" .env
fi

# Prompt for API Key if not set
if [ -z "$API_KEY" ]; then
  read -p "Enter API Key: " API_KEY
  sed -i "s/^API_KEY=.*/API_KEY=$API_KEY/" .env
fi

# Prompt for Secret Key if not set
if [ -z "$SECRET_KEY" ]; then
  read -p "Enter Secret Key: " SECRET_KEY
  sed -i "s/^SECRET_KEY=.*/SECRET_KEY=$SECRET_KEY/" .env
fi

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
until docker exec pr-cybr-agent-db pg_isready -U $DB_USER; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

# Start `server.js` with logging
echo "Starting server.js with logging..."
tmux new-session -d -s server-setup "node src/js/server.js >> server.log 2>&1"

# Ensure Zerotier is installed and configured
echo "Configuring ZeroTier..."
sudo zerotier-cli join $ZT_NETWORK_ID
sudo zerotier-cli set $ZT_NETWORK_ID ip4assignments $ZT_IP_ADDRESS

# Create and name container
NODE_NAME="${DIV_CODE}-NODE-$(date +%s)"
echo "Creating and naming container: $NODE_NAME"
docker rename pr-cybr-mgmt-agent $NODE_NAME

# Trigger Zapier webhook
echo "Triggering Zapier webhook..."
curl -X POST -H "Content-Type: application/json" -d '{"node_name": "'"$(hostname)"'"}' $ZAPIER_WEBHOOK_URL

# Ensure server-sync.sh is executable
echo "Ensuring server-sync.sh is executable..."
chmod +x ./scripts/server-sync.sh

# Set up a cron job to run server-sync.sh every hour
echo "Setting up cron job for server-sync.sh..."
(crontab -l 2>/dev/null; echo "0 * * * * /bin/bash $(pwd)/scripts/server-sync.sh") | crontab -

# Run server-sync.sh script immediately
echo "Running server-sync.sh script..."
if ./scripts/server-sync.sh; then
  echo -e "\033[1;32mAll steps have succeeded! The server node is set up and running.\033[0m"
else
  echo -e "\033[1;31mTest failed. Please check the logs for errors.\033[0m"
  echo "Alternative solution: Ensure all environment variables are set correctly and the network is configured properly."
fi

# Check for tmux configuration files
TMUX_CONF=""
if [ -f "$HOME/.tmux/.tmux.conf" ]; then
  TMUX_CONF="$HOME/.tmux/.tmux.conf"
elif [ -f "$HOME/.tmux/.tmux.conf.local" ]; then
  TMUX_CONF="$HOME/.tmux/.tmux.conf.local"
fi

# Create a new tmux session with separate window panes
echo "Setting up tmux session..."
tmux new-session -d -s server-monitor

# Split the first window horizontally
if [ -n "$TMUX_CONF" ]; then
  # If a tmux config file is found, use it to determine split behavior
  tmux source-file "$TMUX_CONF"
fi
tmux split-window -h

# Send the server.js command to the first pane
tmux send-keys -t server-monitor:0.0 "node src/js/server.js >> server.log 2>&1" C-m

# Send the tail command to the second pane
tmux send-keys -t server-monitor:0.1 "tail -f server.log" C-m

# Split the second pane vertically to create a third pane
tmux split-window -v

# Send the htop command to the third pane
tmux send-keys -t server-monitor:0.2 "htop" C-m

echo "Server setup complete. Use 'tmux attach -t server-monitor' to view the session."