#!/bin/bash

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

# Check for Lynis
if ! command_exists lynis; then
  echo "Lynis is not installed. It is recommended for a security scan."
  read -p "Would you like to install Lynis? (y/n): " install_lynis
  if [ "$install_lynis" == "y" ]; then
    echo "Installing Lynis..."
    # Add Lynis installation commands here
  else
    echo "Skipping Lynis installation."
  fi
else
  echo "Lynis is already installed."
fi

# Function to display a loading animation
loading_animation() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Prompt for user inputs
echo "Step 4: Gathering configuration details..."
read -p "Enter your API Key: " API_KEY
read -p "Enter your email (if applicable): " EMAIL
read -s -p "Enter your password (if applicable): " PASSWORD
echo
read -p "Enter your OpenAI Assistant ID: " ASSISTANT_ID

# Define common directories and files
COMMON_DIRS=("config" "docs" "scripts" "src" "tests" "local_env")
COMMON_FILES=("README.md" ".gitignore" "requirements.txt" "setup.py" "Dockerfile" "docker-compose.yml")

# Function to create directories
create_directories() {
  echo "Step 5: Creating directories..."
  for dir in "${COMMON_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
      mkdir "$dir"
      echo "Created directory: $dir"
    else
      echo "Directory $dir already exists. Skipping."
    fi
  done
}

# Function to create files
create_files() {
  echo "Step 6: Creating files..."
  for file in "${COMMON_FILES[@]}"; do
    if [ ! -f "$file" ]; then
      touch "$file"
      echo "Created file: $file"
    else
      echo "File $file already exists. Skipping."
    fi
  done
}

# Function to setup local deployment configurations
setup_local_deployment() {
  echo "Step 7: Setting up local deployment for $REPO_NAME..."

  # Add a default requirements.txt
  cat > requirements.txt <<EOL
flask
fastapi
uvicorn
requests
pydantic
EOL
  echo "Added default dependencies to requirements.txt."

  # Add a default Dockerfile
  cat > Dockerfile <<EOL
# Base Image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy files
COPY . /app

# Install dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Expose port
EXPOSE 8000

# Run the application
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
EOL
  echo "Added Dockerfile."

  # Add a default docker-compose.yml
  cat > docker-compose.yml <<EOL
version: '3.8'

services:
  app:
    build: .
    container_name: ${REPO_NAME,,}-container
    ports:
      - "8000:8000"
    volumes:
      - .:/app
    environment:
      - API_KEY=$API_KEY
      - ASSISTANT_ID=$ASSISTANT_ID
    command: uvicorn src.main:app --host 0.0.0.0 --port 8000
EOL
  echo "Added docker-compose.yml."

  # Add a local environment file
  cat > local_env/.env <<EOL
# Local Environment Variables
API_KEY=$API_KEY
DATABASE_URL=sqlite:///db.sqlite3
EMAIL=$EMAIL
PASSWORD=$PASSWORD
ASSISTANT_ID=$ASSISTANT_ID
EOL
  echo "Added local environment configuration (.env)."

  # Add default source file
  if [ ! -f "src/main.py" ]; then
    mkdir -p src
    cat > src/main.py <<EOL
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Welcome to $REPO_NAME"}
EOL
    echo "Added FastAPI starter in src/main.py."
  fi
}

# Function to customize repository-specific configurations
customize_repo() {
  echo "Step 8: Customizing repository-specific configurations..."
  case $REPO_NAME in
    PR-CYBR-USER-FEEDBACK-AGENT)
      echo "# Feedback Agent Configuration" > config/feedback_config.yaml
      echo "Added feedback agent-specific files."
      ;;
    PR-CYBR-DATA-INTEGRATION-AGENT)
      echo "# Data Integration Agent Configuration" > config/data_integration.yaml
      echo "Added data integration agent-specific files."
      ;;
    PR-CYBR-CI-CD-AGENT)
      echo "# CI/CD Agent Configuration" > config/ci_cd_config.yaml
      echo "Added CI/CD agent-specific files."
      ;;
    PR-CYBR-MGMT-AGENT)
      echo "# Management Agent Configuration" > config/mgmt_config.yaml
      echo "Added management agent-specific files."
      ;;
    PR-CYBR-MAP)
      echo "# Map Configuration" > config/map_config.yaml
      echo "Added map-specific files."
      ;;
    PR-CYBR-DATABASE-AGENT)
      echo "# Database Agent Configuration" > config/db_config.yaml
      echo "Added database agent-specific files."
      ;;
    PR-CYBR-DOCUMENTATION-AGENT)
      echo "# Documentation Agent Configuration" > config/docs_config.yaml
      echo "Added documentation agent-specific files."
      ;;
    PR-CYBR-FRONTEND-AGENT)
      echo "# Frontend Agent Configuration" > config/frontend_config.yaml
      echo "Added frontend agent-specific files."
      ;;
    PR-CYBR-INFRASTRUCTURE-AGENT)
      echo "# Infrastructure Agent Configuration" > config/infrastructure_config.yaml
      echo "Added infrastructure agent-specific files."
      ;;
    PR-CYBR-PERFORMANCE-AGENT)
      echo "# Performance Agent Configuration" > config/performance_config.yaml
      echo "Added performance agent-specific files."
      ;;
    PR-CYBR-SECURITY-AGENT)
      echo "# Security Agent Configuration" > config/security_config.yaml
      echo "Added security agent-specific files."
      ;;
    PR-CYBR-TESTING-AGENT)
      echo "# Testing Agent Configuration" > config/testing_config.yaml
      echo "Added testing agent-specific files."
      ;;
    *)
      echo "Unknown repository type. No specific files added."
      ;;
  esac
}

# Function to perform system updates
perform_system_updates() {
  echo "Step 9: Performing system updates and upgrades..."
  read -p "Would you like to update and upgrade your system packages? (y/n): " update_system
  if [ "$update_system" == "y" ]; then
    echo "Updating system packages..."
    sudo apt-get update && sudo apt-get upgrade -y &
    loading_animation $!
    echo "System packages updated."
  else
    echo "Skipping system updates."
  fi
}

# Function to run Lynis security scan
run_lynis_scan() {
  echo "Step 10: Running Lynis security scan..."
  if command_exists lynis; then
    sudo lynis audit system &
    loading_animation $!
    echo "Lynis security scan completed."
  else
    echo "Lynis is not installed. Skipping security scan."
  fi
}

# Main script execution
echo "Provisioning backend and local deployment for repository: $REPO_NAME"
create_directories
create_files
setup_local_deployment
customize_repo
perform_system_updates
run_lynis_scan

# Finalization
echo "Provisioning completed for $REPO_NAME."
echo "To start your application, run: docker-compose up"
echo "Your application will be available at http://localhost:8000"
echo "Thank you for using the PR-CYBR Agent Setup Wizard!"
