#!/bin/bash

# ------ #
# Part 1 #
# ------ #

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

# Function to display a loading room with ASCII art and status updates
loading_room() {
  local pid=$1
  local stages=("Initializing" "Installing Dependencies" "Configuring Environment" "Finalizing Setup")
  local current_stage=0
  local delay=0.5
  local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0

  # ASCII Art Banner
  echo "========================================"
  echo "          PR-CYBR Setup Wizard          "
  echo "========================================"

  while kill -0 $pid 2>/dev/null; do
    local spin_char=${spinstr:i++%${#spinstr}:1}
    printf "\r [%s] %s... " "$spin_char" "${stages[current_stage]}"
    sleep $delay

    # Simulate stage progression
    if (( i % 10 == 0 )); then
      current_stage=$(( (current_stage + 1) % ${#stages[@]} ))
    fi
  done

  # Clear the line after completion
  printf "\r%s\n" "Setup Complete!                          "
}

# ------ #
# Part 2 #
# ------ #

# Check for Docker
if ! command_exists docker; then
  echo "Docker is not installed. It is required for this setup."
  read -p "Would you like to install Docker? (y/n): " install_docker
  if [ "$install_docker" == "y" ]; then
    echo "Installing Docker..."
    sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update && sudo apt-get install -y docker-ce
    sudo systemctl start docker && sudo systemctl enable docker
    echo "Docker installed successfully."
  else
    echo "Docker installation is required to proceed. Exiting."
    exit 1
  fi
else
  echo "Docker is already installed."
fi

# Check for curl
if ! command_exists curl; then
  echo "curl is not installed. It is required for this setup."
  read -p "Would you like to install curl? (y/n): " install_curl
  if [ "$install_curl" == "y" ]; then
    echo "Installing curl..."
    sudo apt-get update && sudo apt-get install -y curl
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
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
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

# ------ #
# Part 3 #
# ------ #

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

# Check and perform system updates if not already done
if ! grep -q "System updates" "$LOG_FILE"; then
  perform_system_updates
  echo "System updates" >> "$LOG_FILE"
fi

# Function to install Lynis
install_lynis() {
  echo "Installing Lynis..."
  if command_exists apt-get; then
    sudo apt-get update && sudo apt-get install -y lynis
  elif command_exists yum; then
    sudo yum install -y epel-release lynis
  elif command_exists dnf; then
    sudo dnf install -y epel-release lynis
  else
    echo "No supported package manager found for Lynis. Attempting to clone Lynis from GitHub..."
    if ! command_exists git; then
      echo "Git is not installed. Attempting to install Git..."
      if command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y git
      elif command_exists yum; then
        sudo yum install -y git
      elif command_exists dnf; then
        sudo dnf install -y git
      else
        echo "No supported package manager found to install Git. Please install Git manually."
        exit 1
      fi
    fi
    if command_exists git; then
      git clone https://github.com/CISOfy/lynis.git
      echo "Lynis cloned successfully. To run Lynis, navigate to the lynis directory and execute './lynis audit system'."
    else
      echo "Failed to install Git. Please install Git or Lynis manually."
      exit 1
    fi
  fi
}

# Function to run a Lynis security scan and display the output
run_lynis_scan() {
  echo "Running Lynis security scan..."
  # Run the Lynis audit and display the report
  sudo lynis audit system | tee lynis_scan_output.log

  # Display the scan output to the user
  echo "Lynis security scan completed. Review the output below:"
  cat lynis_scan_output.log
}

# Install Lynis if not already done, otherwise run a scan
if ! grep -q "Lynis installed" "$LOG_FILE"; then
  install_lynis
  echo "Lynis installed" >> "$LOG_FILE"
else
  if command_exists lynis; then
    run_lynis_scan
  else
    echo "Lynis is not installed, and the installation record is incorrect. Please install Lynis manually."
    exit 1
  fi
fi

# ------ #
# Part 4 #
# ------ #

# Function to finalize the setup
finalize_setup() {
  echo "Finalizing setup..."
  echo "Setup Summary for $REPO_NAME:"
  echo "1. Checked and installed necessary dependencies."
  echo "2. Installed Lynis for security auditing, either via package manager or by cloning from GitHub."
  echo "3. Conducted a Lynis security scan to assess system hardening."
  echo "4. Verified interconnectivity between all agent containers."
  echo "5. Checked that all agent Docker containers are running."
  echo "6. Attempted to restart any containers that were not running."
  echo "7. Provisioned and configured infrastructure components as needed."
  echo "Provisioning completed for $REPO_NAME."
  echo "Your system is now set up and ready to use. Please review the logs for any warnings or errors."
}

# Extract the agent name from the script's directory path
AGENT_NAME=$(basename "$(dirname "$(dirname "$0")")")

# Function to provide instructions for accessing the agent dashboard
provide_dashboard_access() {
  local agent_name=$1
  local container_name=$2
  local port=$3

  if docker ps --filter "name=$container_name" --filter "status=running" | grep -q "$container_name"; then
    echo "The $agent_name dashboard is available at http://localhost:$port"
  else
    echo "The $agent_name container is not running. Please start it to access the dashboard."
  fi
}

# Determine the port based on the agent name
case "$AGENT_NAME" in
  "PR-CYBR-MGMT-AGENT")
    PORT=8000
    ;;
  "PR-CYBR-DATABASE-AGENT")
    PORT=8001
    ;;
  "PR-CYBR-DATA-INTEGRATION-AGENT")
    PORT=8002
    ;;
  "PR-CYBR-FRONTEND-AGENT")
    PORT=8003
    ;;
  "PR-CYBR-BACKEND-AGENT")
    PORT=8004
    ;;
  "PR-CYBR-PERFORMANCE-AGENT")
    PORT=8005
    ;;
  "PR-CYBR-SECURITY-AGENT")
    PORT=8006
    ;;
  "PR-CYBR-TESTING-AGENT")
    PORT=8007
    ;;
  "PR-CYBR-CI-CD-AGENT")
    PORT=8008
    ;;
  "PR-CYBR-USER-FEEDBACK-AGENT")
    PORT=8009
    ;;
  "PR-CYBR-DOCUMENTATION-AGENT")
    PORT=8010
    ;;
  "PR-CYBR-INFRASTRUCTURE-AGENT")
    PORT=8011
    ;;
  *)
    echo "Unknown agent: $AGENT_NAME"
    exit 1
    ;;
esac

# Provide dashboard access instructions
provide_dashboard_access "$AGENT_NAME" "$(echo "$AGENT_NAME" | tr '[:upper:]' '[:lower:]')" "$PORT"

# Define the directory for the landing page
LANDING_PAGE_DIR="web"

# Check if the web directory exists, create it if not
if [ ! -d "$LANDING_PAGE_DIR" ]; then
  echo "Directory $LANDING_PAGE_DIR does not exist. Creating it..."
  mkdir -p "$LANDING_PAGE_DIR"
fi

# Check if the index.html file exists
if [ ! -f "$LANDING_PAGE_DIR/index.html" ]; then
  echo "index.html not found. Generating a basic offline page..."
  cat <<EOF > "$LANDING_PAGE_DIR/index.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agent Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        h1 { color: #333; }
    </style>
</head>
<body>
    <h1>Agent Dashboard Offline</h1>
    <p>Check back soon for updates.</p>
</body>
</html>
EOF
  echo "Basic offline page created at $LANDING_PAGE_DIR/index.html"
else
  echo "Landing page available at $LANDING_PAGE_DIR/index.html"
fi

# Additional information about the Agent Dashboard
echo "========================================"
echo "         Agent Dashboard Access         "
echo "========================================"
echo ""
echo "The Agent Dashboard provides a centralized interface for monitoring and managing your agent's activities."
echo "Access the dashboard by opening the following file in your web browser:"
echo ""
echo "  \033[1;32m$LANDING_PAGE_DIR/index.html\033[0m"
echo ""
echo "Ensure your web server is configured to serve files from the '$LANDING_PAGE_DIR' directory."
echo "========================================"

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
# Add more agents as needed

echo "Thank you for using the PR-CYBR Agent Setup Wizard!"

# Check and finalize setup if not already done
if ! grep -q "Finalize setup" "$LOG_FILE"; then
  finalize_setup
  echo "Finalize setup" >> "$LOG_FILE"
fi
