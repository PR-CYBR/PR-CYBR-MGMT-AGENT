#!/bin/bash
# This script sets up the agent using Docker

# Check if the agent name is provided as an environment variable
if [ -z "$AGENT_NAME" ]; then
  echo "Error: AGENT_NAME environment variable is not set."
  exit 1
fi

echo "Setting up the agent environment for $AGENT_NAME with Docker..."

# Use the agent name as the Docker image name
IMAGE_NAME="$AGENT_NAME"

# Build the Docker image
docker build -t $IMAGE_NAME .

# Run the Docker container
docker run -it --rm $IMAGE_NAME

echo "Agent setup complete for $AGENT_NAME with Docker."