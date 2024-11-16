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

# Function to display a loading animation
loading_animation() {
  local pid=$1
  local delay=0.1
  local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local spin_char=${spinstr:i++%${#spinstr}:1}
    printf " [%s]  " "$spin_char"
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Check for Docker
if ! command_exists docker; then
  echo "Docker is not installed. It is required for this setup."
  read -p "Would you like to install Docker? (y/n): " install_docker
  if [ "$install_docker" == "y" ]; then
    echo "Installing Docker..."
    
    # Update the package database
    sudo apt-get update
    
    # Install packages to allow apt to use a repository over HTTPS
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    
    # Add Docker's official APT repository
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    
    # Update the package database again with Docker packages from the newly added repo
    sudo apt-get update
    
    # Install Docker
    sudo apt-get install -y docker-ce
    
    # Verify Docker installation
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker installed successfully."
  else
    echo "Docker installation is required to proceed. Exiting."
    exit 1
  fi
else
  echo "Docker is already installed."
fi

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check for curl
if ! command_exists curl; then
  echo "curl is not installed. It is required for this setup."
  read -p "Would you like to install curl? (y/n): " install_curl
  if [ "$install_curl" == "y" ]; then
    echo "Installing curl..."
    sudo apt-get update
    sudo apt-get install -y curl
    echo "curl installed successfully."
  else
    echo "curl installation is required to proceed. Exiting."
    exit 1
  fi
else
  echo "curl is already installed."
fi

# Check for Docker Compose
if ! command_exists docker-compose; then
  echo "Docker Compose is not installed. It is required for this setup."
  read -p "Would you like to install Docker Compose? (y/n): " install_compose
  if [ "$install_compose" == "y" ]; then
    echo "Installing Docker Compose..."
    
    # Download the current stable release of Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    
    # Apply executable permissions to the binary
    sudo chmod +x /usr/local/bin/docker-compose
    
    # Verify Docker Compose installation
    if docker-compose --version; then
      echo "Docker Compose installed successfully."
    else
      echo "Failed to install Docker Compose. Please check the installation steps and try again."
      exit 1
    fi
  else
    echo "Docker Compose installation is required to proceed. Exiting."
    exit 1
  fi
else
  echo "Docker Compose is already installed."
fi

# Function to check if a setup step has been completed
check_setup_step() {
  grep -q "$1" "$LOG_FILE"
}

# Function to mark a setup step as completed
mark_setup_step() {
  echo "$1" >> "$LOG_FILE"
}

# Function to perform system updates
perform_system_updates() {
  echo "Performing system updates..."

  if command_exists apt-get; then
    echo "Using apt-get for updates..."
    sudo apt-get update && sudo apt-get upgrade -y
  elif command_exists yum; then
    echo "Using yum for updates..."
    sudo yum check-update && sudo yum update -y
  elif command_exists dnf; then
    echo "Using dnf for updates..."
    sudo dnf check-update && sudo dnf upgrade -y
  else
    echo "No supported package manager found. Please update your system manually."
    exit 1
  fi
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check and perform system updates if not already done
if ! check_setup_step "System updates"; then
  perform_system_updates
  mark_setup_step "System updates"
fi

# Function to install Lynis
install_lynis() {
  echo "Installing Lynis..."

  if command_exists apt-get; then
    echo "Using apt-get to install Lynis..."
    sudo apt-get update && sudo apt-get install -y lynis
  elif command_exists yum; then
    echo "Using yum to install Lynis..."
    sudo yum install -y epel-release
    sudo yum install -y lynis
  elif command_exists dnf; then
    echo "Using dnf to install Lynis..."
    sudo dnf install -y epel-release
    sudo dnf install -y lynis
  else
    echo "No supported package manager found. Please install Lynis manually."
    exit 1
  fi
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to run a Lynis security scan and check the score
run_lynis_scan() {
  echo "Running Lynis security scan..."
  # Run the Lynis audit and save the report to a temporary file
  sudo lynis audit system --quiet --no-colors > /tmp/lynis-report.txt

  # Extract the security score from the report
  local score=$(grep "Hardening index" /tmp/lynis-report.txt | awk '{print $3}' | tr -d '%')

  # Check if the score is greater than 50
  if [ "$score" -gt 50 ]; then
    echo "Lynis security scan passed with a score of $score%."
  else
    echo "Lynis security scan failed with a score of $score%. Please improve your system's security before proceeding."
    exit 1
  fi
}

# Check and install Lynis if not already done
if ! check_setup_step "Lynis installation"; then
  if ! command_exists lynis; then
    install_lynis
  fi
  mark_setup_step "Lynis installation"
fi

# Run Lynis security scan if not already done
if ! check_setup_step "Lynis security scan"; then
  run_lynis_scan
  mark_setup_step "Lynis security scan"
fi

# Docker network setup
DOCKER_NETWORK="pr-cybr-network"

# Check and create Docker network if not already done
if ! check_setup_step "Docker network setup"; then
  if ! docker network ls | grep -q $DOCKER_NETWORK; then
    echo "Creating Docker network: $DOCKER_NETWORK"
    docker network create $DOCKER_NETWORK
    mark_setup_step "Docker network setup"
  else
    echo "Docker network $DOCKER_NETWORK already exists."
  fi
fi

# Function to clone additional repositories
clone_additional_repos() {
  echo "Cloning additional repositories..."

  # PR-CYBR-MGMT-AGENT
  if [ ! -d "PR-CYBR-MGMT-AGENT" ]; then
    git clone https://github.com/PR-CYBR/PR-CYBR-MGMT-AGENT.git
  fi

  # PR-CYBR-DATA-INTEGRATION-AGENT
  if [ ! -d "PR-CYBR-DATA-INTEGRATION-AGENT" ]; then
    git clone https://github.com/PR-CYBR/PR-CYBR-DATA-INTEGRATION-AGENT.git
  fi

  # PR-CYBR-DATABASE-AGENT
  if [ ! -d "PR-CYBR-DATABASE-AGENT" ]; then
    git clone https://github.com/PR-CYBR/PR-CYBR-DATABASE-AGENT.git
  fi

  # PR-CYBR-FRONTEND-AGENT
  if [ ! -d "PR-CYBR-FRONTEND-AGENT" ]; then
    git clone https://github.com/PR-CYBR/PR-CYBR-FRONTEND-AGENT.git
  fi

  # PR-CYBR-BACKEND-AGENT
  if [ ! -d "PR-CYBR-BACKEND-AGENT" ]; then
    git clone https://github.com/PR-CYBR/PR-CYBR-BACKEND-AGENT.git
  fi

  # PR-CYBR-PERFORMANCE-AGENT
  if [ ! -d "PR-CYBR-PERFORMANCE-AGENT" ]; then
    git clone https://github.com/PR-CYBR/PR-CYBR-PERFORMANCE-AGENT.git
  fi

  # PR-CYBR-SECURITY-AGENT
  if [ ! -d "PR-CYBR-SECURITY-AGENT" ]; then
    git clone https://github.com/PR-CYBR/PR-CYBR-SECURITY-AGENT.git
  fi

  # PR-CYBR-TESTING-AGENT
  if [ ! -d "PR-CYBR-TESTING-AGENT" ]; then
    git clone https://github.com/PR-CYBR/PR-CYBR-TESTING-AGENT.git
  fi

  # PR-CYBR-CI-CD-AGENT
  if [ ! -d "PR-CYBR-CI-CD-AGENT" ]; then
    git clone https://github.com/PR-CYBR/PR-CYBR-CI-CD-AGENT.git
  fi

  # PR-CYBR-USER-FEEDBACK-AGENT
  if [ ! -d "PR-CYBR-USER-FEEDBACK-AGENT" ]; then
    git clone https://github.com/PR-CYBR/PR-CYBR-USER-FEEDBACK-AGENT.git
  fi

  # PR-CYBR-DOCUMENTATION-AGENT
  if [ ! -d "PR-CYBR-DOCUMENTATION-AGENT" ]; then
    git clone https://github.com/PR-CYBR/PR-CYBR-DOCUMENTATION-AGENT.git
  fi

  # PR-CYBR-INFRASTRUCTURE-AGENT
  if [ ! -d "PR-CYBR-INFRASTRUCTURE-AGENT" ]; then
    git clone https://github.com/PR-CYBR/PR-CYBR-INFRASTRUCTURE-AGENT.git
  fi
}

# Function to set up cloned repositories
setup_cloned_repos() {
  echo "Setting up cloned repositories..."

  # PR-CYBR-MGMT-AGENT
  if [ -d "PR-CYBR-MGMT-AGENT" ]; then
    cd PR-CYBR-MGMT-AGENT
    if [ -f "scripts/local_setup.sh" ]; then
      bash scripts/local_setup.sh
    fi
    cd ..
  fi

  # PR-CYBR-DATA-INTEGRATION-AGENT
  if [ -d "PR-CYBR-DATA-INTEGRATION-AGENT" ]; then
    cd PR-CYBR-DATA-INTEGRATION-AGENT
    if [ -f "scripts/local_setup.sh" ]; then
      bash scripts/local_setup.sh
    fi
    cd ..
  fi

  # PR-CYBR-DATABASE-AGENT
  if [ -d "PR-CYBR-DATABASE-AGENT" ]; then
    cd PR-CYBR-DATABASE-AGENT
    if [ -f "scripts/local_setup.sh" ]; then
      bash scripts/local_setup.sh
    fi
    cd ..
  fi

  # PR-CYBR-FRONTEND-AGENT
  if [ -d "PR-CYBR-FRONTEND-AGENT" ]; then
    cd PR-CYBR-FRONTEND-AGENT
    if [ -f "scripts/local_setup.sh" ]; then
      bash scripts/local_setup.sh
    fi
    cd ..
  fi

  # PR-CYBR-BACKEND-AGENT
  if [ -d "PR-CYBR-BACKEND-AGENT" ]; then
    cd PR-CYBR-BACKEND-AGENT
    if [ -f "scripts/local_setup.sh" ]; then
      bash scripts/local_setup.sh
    fi
    cd ..
  fi

  # PR-CYBR-PERFORMANCE-AGENT
  if [ -d "PR-CYBR-PERFORMANCE-AGENT" ]; then
    cd PR-CYBR-PERFORMANCE-AGENT
    if [ -f "scripts/local_setup.sh" ]; then
      bash scripts/local_setup.sh
    fi
    cd ..
  fi

  # PR-CYBR-SECURITY-AGENT
  if [ -d "PR-CYBR-SECURITY-AGENT" ]; then
    cd PR-CYBR-SECURITY-AGENT
    if [ -f "scripts/local_setup.sh" ]; then
      bash scripts/local_setup.sh
    fi
    cd ..
  fi

  # PR-CYBR-TESTING-AGENT
  if [ -d "PR-CYBR-TESTING-AGENT" ]; then
    cd PR-CYBR-TESTING-AGENT
    if [ -f "scripts/local_setup.sh" ]; then
      bash scripts/local_setup.sh
    fi
    cd ..
  fi

  # PR-CYBR-CI-CD-AGENT
  if [ -d "PR-CYBR-CI-CD-AGENT" ]; then
    cd PR-CYBR-CI-CD-AGENT
    if [ -f "scripts/local_setup.sh" ]; then
      bash scripts/local_setup.sh
    fi
    cd ..
  fi

  # PR-CYBR-USER-FEEDBACK-AGENT
  if [ -d "PR-CYBR-USER-FEEDBACK-AGENT" ]; then
    cd PR-CYBR-USER-FEEDBACK-AGENT
    if [ -f "scripts/local_setup.sh" ]; then
      bash scripts/local_setup.sh
    fi
    cd ..
  fi

  # PR-CYBR-DOCUMENTATION-AGENT
  if [ -d "PR-CYBR-DOCUMENTATION-AGENT" ]; then
    cd PR-CYBR-DOCUMENTATION-AGENT
    if [ -f "scripts/local_setup.sh" ]; then
      bash scripts/local_setup.sh
    fi
    cd ..
  fi

  # PR-CYBR-INFRASTRUCTURE-AGENT
  if [ -d "PR-CYBR-INFRASTRUCTURE-AGENT" ]; then
    cd PR-CYBR-INFRASTRUCTURE-AGENT
    if [ -f "scripts/local_setup.sh" ]; then
      bash scripts/local_setup.sh
    fi
    cd ..
  fi
}

# Check and clone additional repositories if not already done
if ! check_setup_step "Clone additional repos"; then
  clone_additional_repos
  mark_setup_step "Clone additional repos"
fi

# Function to check if a Docker container is running
is_container_running() {
  local container_name=$1
  docker ps --filter "name=$container_name" --filter "status=running" | grep -q "$container_name"
}

# Function to test interconnectivity between containers
test_container_connectivity() {
  local source_container=$1
  local target_container=$2
  local target_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$target_container")

  if [ -z "$target_ip" ]; then
    echo "Failed to get IP address for $target_container."
    return 1
  fi

  docker exec "$source_container" ping -c 1 "$target_ip" >/dev/null 2>&1
}

# Check and set up cloned repositories if not already done
check_and_setup_repos() {
  local containers=("pr-cybr-mgmt-agent" "pr-cybr-data-integration-agent" "pr-cybr-database-agent" "pr-cybr-frontend-agent" "pr-cybr-backend-agent" "pr-cybr-performance-agent" "pr-cybr-security-agent" "pr-cybr-testing-agent" "pr-cybr-ci-cd-agent" "pr-cybr-user-feedback-agent" "pr-cybr-documentation-agent" "pr-cybr-infrastructure-agent")

  for container in "${containers[@]}"; do
    if ! is_container_running "$container"; then
      echo "Container $container is not running. Please start it before proceeding."
      exit 1
    fi
  done

  echo "All containers are running. Testing interconnectivity..."

  # Example interconnectivity test between two containers
  if test_container_connectivity "pr-cybr-mgmt-agent" "pr-cybr-database-agent"; then
    echo "Interconnectivity test passed between pr-cybr-mgmt-agent and pr-cybr-database-agent."
  else
    echo "Interconnectivity test failed between pr-cybr-mgmt-agent and pr-cybr-database-agent."
    exit 1
  fi

  # Add more interconnectivity tests as needed
}

# Function to check if a Docker container is running
is_container_running() {
  local container_name=$1
  docker ps --filter "name=$container_name" --filter "status=running" | grep -q "$container_name"
}

# Function to attempt restarting a container
attempt_restart_container() {
  local container_name=$1
  local attempts=0
  local max_attempts=3

  while [ $attempts -lt $max_attempts ]; do
    if is_container_running "$container_name"; then
      echo "Container $container_name is running."
      return 0
    else
      echo "Attempting to start container $container_name (Attempt $((attempts + 1))/$max_attempts)..."
      docker start "$container_name" || docker run -d --name "$container_name" "$container_name"
      sleep 5
    fi
    attempts=$((attempts + 1))
  done

  echo "Failed to start container $container_name after $max_attempts attempts."
  return 1
}

# Function to output troubleshooting information
output_troubleshooting_info() {
  local container_name=$1
  echo "Troubleshooting information for $container_name:"
  echo "Container logs:"
  docker logs "$container_name" || echo "No logs available for $container_name."
  echo "Container status:"
  docker inspect "$container_name" || echo "Failed to inspect $container_name."
}

# Check and set up cloned repositories if not already done
check_and_setup_repos() {
  local containers=("pr-cybr-mgmt-agent" "pr-cybr-data-integration-agent" "pr-cybr-database-agent" "pr-cybr-frontend-agent" "pr-cybr-backend-agent" "pr-cybr-performance-agent" "pr-cybr-security-agent" "pr-cybr-testing-agent" "pr-cybr-ci-cd-agent" "pr-cybr-user-feedback-agent" "pr-cybr-documentation-agent" "pr-cybr-infrastructure-agent")

  for container in "${containers[@]}"; do
    if ! attempt_restart_container "$container"; then
      echo "Container $container is not running. Please check the following information to troubleshoot:"
      output_troubleshooting_info "$container"
      exit 1
    fi
  done

  echo "All containers are running. Testing interconnectivity..."

  # Example interconnectivity test between two containers
  if test_container_connectivity "pr-cybr-mgmt-agent" "pr-cybr-database-agent"; then
    echo "Interconnectivity test passed between pr-cybr-mgmt-agent and pr-cybr-database-agent."
  else
    echo "Interconnectivity test failed between pr-cybr-mgmt-agent and pr-cybr-database-agent."
    exit 1
  fi

  # Add more interconnectivity tests as needed
}

# Run the check and setup process
check_and_setup_repos

# Function to finalize the setup
finalize_setup() {
  echo "Finalizing setup..."
  echo "Provisioning completed for $REPO_NAME."

  # Instructions for starting the application
  echo "To start your application, run: docker-compose up -d"
  echo "Your application will be available at http://localhost:8000"

  # Information about accessing logs
  echo "To view application logs, use: docker-compose logs -f"
  echo "For individual container logs, use: docker logs <container_name>"

  # Instructions for managing containers
  echo "To stop the application, run: docker-compose down"
  echo "To restart a specific container, use: docker restart <container_name>"

  # Landing page information
  echo "Landing page available at $LANDING_PAGE_DIR/index.html"

  # Troubleshooting tips
  echo "If you encounter issues, consider the following steps:"
  echo "1. Check container logs for errors using the logs commands above."
  echo "2. Ensure all containers are running with: docker ps"
  echo "3. Verify network connectivity between containers if applicable."
  echo "4. Consult the documentation or support resources for further assistance."

  # List of Agent Repositories
  echo "Agent Repositories and Resources:"
  echo "1. PR-CYBR-MGMT-AGENT"
  echo "   - GitHub: https://github.com/PR-CYBR/PR-CYBR-MGMT-AGENT"
  echo "   - Docker: https://hub.docker.com/r/prcybr/pr-cybr-mgmt-agent"
  echo "   - Pull Command: docker pull prcybr/pr-cybr-mgmt-agent"
  echo "2. PR-CYBR-DATA-INTEGRATION-AGENT"
  echo "   - GitHub: https://github.com/PR-CYBR/PR-CYBR-DATA-INTEGRATION-AGENT"
  echo "   - Docker: https://hub.docker.com/r/prcybr/pr-cybr-data-integration-agent"
  echo "   - Pull Command: docker pull prcybr/pr-cybr-data-integration-agent"
  echo "3. PR-CYBR-DATABASE-AGENT"
  echo "   - GitHub: https://github.com/PR-CYBR/PR-CYBR-DATABASE-AGENT"
  echo "   - Docker: https://hub.docker.com/r/prcybr/pr-cybr-database-agent"
  echo "   - Pull Command: docker pull prcybr/pr-cybr-database-agent"
  echo "4. PR-CYBR-FRONTEND-AGENT"
  echo "   - GitHub: https://github.com/PR-CYBR/PR-CYBR-FRONTEND-AGENT"
  echo "   - Docker: https://hub.docker.com/r/prcybr/pr-cybr-frontend-agent"
  echo "   - Pull Command: docker pull prcybr/pr-cybr-frontend-agent"
  echo "5. PR-CYBR-BACKEND-AGENT"
  echo "   - GitHub: https://github.com/PR-CYBR/PR-CYBR-BACKEND-AGENT"
  echo "   - Docker: https://hub.docker.com/r/prcybr/pr-cybr-backend-agent"
  echo "   - Pull Command: docker pull prcybr/pr-cybr-backend-agent"
  echo "6. PR-CYBR-PERFORMANCE-AGENT"
  echo "   - GitHub: https://github.com/PR-CYBR/PR-CYBR-PERFORMANCE-AGENT"
  echo "   - Docker: https://hub.docker.com/r/prcybr/pr-cybr-performance-agent"
  echo "   - Pull Command: docker pull prcybr/pr-cybr-performance-agent"
  echo "7. PR-CYBR-SECURITY-AGENT"
  echo "   - GitHub: https://github.com/PR-CYBR/PR-CYBR-SECURITY-AGENT"
  echo "   - Docker: https://hub.docker.com/r/prcybr/pr-cybr-security-agent"
  echo "   - Pull Command: docker pull prcybr/pr-cybr-security-agent"
  echo "8. PR-CYBR-TESTING-AGENT"
  echo "   - GitHub: https://github.com/PR-CYBR/PR-CYBR-TESTING-AGENT"
  echo "   - Docker: https://hub.docker.com/r/prcybr/pr-cybr-testing-agent"
  echo "   - Pull Command: docker pull prcybr/pr-cybr-testing-agent"
  echo "9. PR-CYBR-CI-CD-AGENT"
  echo "   - GitHub: https://github.com/PR-CYBR/PR-CYBR-CI-CD-AGENT"
  echo "   - Docker: https://hub.docker.com/r/prcybr/pr-cybr-ci-cd-agent"
  echo "   - Pull Command: docker pull prcybr/pr-cybr-ci-cd-agent"
  echo "10. PR-CYBR-USER-FEEDBACK-AGENT"
  echo "    - GitHub: https://github.com/PR-CYBR/PR-CYBR-USER-FEEDBACK-AGENT"
  echo "    - Docker: https://hub.docker.com/r/prcybr/pr-cybr-user-feedback-agent"
  echo "    - Pull Command: docker pull prcybr/pr-cybr-user-feedback-agent"
  echo "11. PR-CYBR-DOCUMENTATION-AGENT"
  echo "    - GitHub: https://github.com/PR-CYBR/PR-CYBR-DOCUMENTATION-AGENT"
  echo "    - Docker: https://hub.docker.com/r/prcybr/pr-cybr-documentation-agent"
  echo "    - Pull Command: docker pull prcybr/pr-cybr-documentation-agent"
  echo "12. PR-CYBR-INFRASTRUCTURE-AGENT"
  echo "    - GitHub: https://github.com/PR-CYBR/PR-CYBR-INFRASTRUCTURE-AGENT"
  echo "    - Docker: https://hub.docker.com/r/prcybr/pr-cybr-infrastructure-agent"
  echo "    - Pull Command: docker pull prcybr/pr-cybr-infrastructure-agent"

  echo "Thank you for using the PR-CYBR Agent Setup Wizard!"
}

# Check and finalize setup if not already done
if ! check_setup_step "Finalize setup"; then
  finalize_setup
  mark_setup_step "Finalize setup"
fi
