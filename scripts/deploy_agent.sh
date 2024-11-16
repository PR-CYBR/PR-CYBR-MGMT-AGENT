#!/bin/bash
# This script deploys the agent using Docker

# Check if the agent name is provided as an environment variable
if [ -z "$AGENT_NAME" ]; then
  echo "Error: AGENT_NAME environment variable is not set."
  exit 1
fi

echo "Deploying the agent $AGENT_NAME..."

# Use the agent name as the Docker image name
IMAGE_NAME="$AGENT_NAME"

# Run the Docker container
docker run -d --name $AGENT_NAME $IMAGE_NAME

echo "Agent $AGENT_NAME deployed successfully."
