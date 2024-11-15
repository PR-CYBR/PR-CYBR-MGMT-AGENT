#!/bin/bash

# Log file setup
LOG_FILE="setup.log"
exec > >(tee -i $LOG_FILE)
exec 2>&1

# Introduction
echo "Welcome to the PR-CYBR Agent Setup Wizard!"
echo "This script will guide you through setting up your local development environment."

# Get the repository name from the current working directory
REPO_NAME=$(basename "$PWD")

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check for Docker
if ! command_exists docker; then
  echo "Docker is not installed. It is required for this setup."
  read -p "Would you like to install Docker? (y/n): " install_docker
  if [ "$install_docker" == "y" ]; then
    echo "Installing Docker..."
    # Add Docker installation commands here
  else
    echo "Docker installation is required to proceed. Exiting."
    exit 1
  fi
else
  echo "Docker is already installed."
fi

# Check for Docker Compose
if ! command_exists docker-compose; then
  echo "Docker Compose is not installed. It is required for this setup."
  read -p "Would you like to install Docker Compose? (y/n): " install_compose
  if [ "$install_compose" == "y" ]; then
    echo "Installing Docker Compose..."
    # Add Docker Compose installation commands here
  else
    echo "Docker Compose installation is required to proceed. Exiting."
    exit 1
  fi
else
  echo "Docker Compose is already installed."
fi

# Create a Docker network for inter-container communication
DOCKER_NETWORK="pr-cybr-network"
if ! docker network ls | grep -q $DOCKER_NETWORK; then
  echo "Creating Docker network: $DOCKER_NETWORK"
  docker network create $DOCKER_NETWORK
else
  echo "Docker network $DOCKER_NETWORK already exists."
fi

# Function to clone additional agent repositories
clone_additional_repos() {
  echo "Step 2: Cloning additional agent repositories..."
  AGENT_REPOS=(
    "PR-CYBR-MGMT-AGENT:https://github.com/PR-CYBR/PR-CYBR-MGMT-AGENT"
    "PR-CYBR-DATA-INTEGRATION-AGENT:https://github.com/PR-CYBR/PR-CYBR-DATA-INTEGRATION-AGENT"
    "PR-CYBR-DATABASE-AGENT:https://github.com/PR-CYBR/PR-CYBR-DATABASE-AGENT"
    "PR-CYBR-FRONTEND-AGENT:https://github.com/PR-CYBR/PR-CYBR-FRONTEND-AGENT"
    "PR-CYBR-BACKEND-AGENT:https://github.com/PR-CYBR/PR-CYBR-BACKEND-AGENT"
    "PR-CYBR-PERFORMANCE-AGENT:https://github.com/PR-CYBR/PR-CYBR-PERFORMANCE-AGENT"
    "PR-CYBR-SECURITY-AGENT:https://github.com/PR-CYBR/PR-CYBR-SECURITY-AGENT"
    "PR-CYBR-TESTING-AGENT:https://github.com/PR-CYBR/PR-CYBR-TESTING-AGENT"
    "PR-CYBR-CI-CD-AGENT:https://github.com/PR-CYBR/PR-CYBR-CI-CD-AGENT"
    "PR-CYBR-USER-FEEDBACK-AGENT:https://github.com/PR-CYBR/PR-CYBR-USER-FEEDBACK-AGENT"
    "PR-CYBR-DOCUMENTATION-AGENT:https://github.com/PR-CYBR/PR-CYBR-DOCUMENTATION-AGENT"
    "PR-CYBR-INFRASTRUCTURE-AGENT:https://github.com/PR-CYBR/PR-CYBR-INFRASTRUCTURE-AGENT"
  )

  echo "Would you like to clone additional agent repositories?"
  echo "1. Clone all remaining agents"
  echo "2. Select specific agents to clone"
  echo "3. Skip cloning"
  read -p "Enter your choice (1/2/3): " clone_choice

  if [ "$clone_choice" == "1" ]; then
    for repo in "${AGENT_REPOS[@]}"; do
      IFS=':' read -r name url <<< "$repo"
      if [ "$name" != "$REPO_NAME" ]; then
        echo "Cloning $name..."
        git clone "$url" &
        loading_animation $!
      fi
    done
  elif [ "$clone_choice" == "2" ]; then
    echo "Select agents to clone (separate numbers with spaces):"
    for i in "${!AGENT_REPOS[@]}"; do
      IFS=':' read -r name url <<< "${AGENT_REPOS[$i]}"
      echo "$i. $name"
    done
    read -p "Enter your choices: " selected_agents
    for index in $selected_agents; do
      IFS=':' read -r name url <<< "${AGENT_REPOS[$index]}"
      if [ "$name" != "$REPO_NAME" ]; then
        echo "Cloning $name..."
        git clone "$url" &
        loading_animation $!
      fi
    done
  else
    echo "Skipping additional cloning."
  fi
}

# Function to run setup for cloned repositories
setup_cloned_repos() {
  echo "Step 3: Setting up cloned repositories..."
  for dir in */; do
    if [ -d "$dir" ] && [ "$dir" != "$REPO_NAME/" ]; then
      echo "Setting up $dir..."
      (cd "$dir" && ./local_setup.sh) &
      loading_animation $!
    fi
  done
}

# Function to check if a setup step has already been completed
check_setup_step() {
  local step_name=$1
  grep -q "$step_name" setup.log
}

# Function to mark a setup step as completed
mark_setup_step() {
  local step_name=$1
  echo "$step_name completed" >> setup.log
}

# Function to provision a simple landing page
provision_landing_page() {
  echo "Step 4: Provisioning landing page..."
  LANDING_PAGE_DIR="landing_page"
  if [ ! -d "$LANDING_PAGE_DIR" ]; then
    mkdir "$LANDING_PAGE_DIR"
    echo "<html><body style='background-color:black; color:white; text-align:center;'><h1>Local Agent Deployment Success</h1></body></html>" > "$LANDING_PAGE_DIR/index.html"
    echo "Landing page created at $LANDING_PAGE_DIR/index.html"
  else
    echo "Landing page already exists."
  fi
}

# Main script execution
echo "Provisioning backend and local deployment for repository: $REPO_NAME"

# Check and perform each setup step only if not already completed
if ! check_setup_step "Docker network setup"; then
  # Create Docker network
  if ! docker network ls | grep -q $DOCKER_NETWORK; then
    echo "Creating Docker network: $DOCKER_NETWORK"
    docker network create $DOCKER_NETWORK
    mark_setup_step "Docker network setup"
  else
    echo "Docker network $DOCKER_NETWORK already exists."
  fi
fi

if ! check_setup_step "Clone additional repos"; then
  clone_additional_repos
  mark_setup_step "Clone additional repos"
fi

if ! check_setup_step "Setup cloned repos"; then
  setup_cloned_repos
  mark_setup_step "Setup cloned repos"
fi

if ! check_setup_step "Provision landing page"; then
  provision_landing_page
  mark_setup_step "Provision landing page"
fi

# Finalization
echo "Provisioning completed for $REPO_NAME."
echo "To start your application, run: docker-compose up"
echo "Your application will be available at http://localhost:8000"
echo "Landing page available at $LANDING_PAGE_DIR/index.html"
echo "Thank you for using the PR-CYBR Agent Setup Wizard!"
