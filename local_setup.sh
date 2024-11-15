#!/bin/bash

# Script to provision backend files & directories for PR-CYBR Agents with local deployment setup

# Get the repository name from the current working directory
REPO_NAME=$(basename "$PWD")

# Define common directories and files
COMMON_DIRS=("config" "docs" "scripts" "src" "tests" "local_env")
COMMON_FILES=("README.md" ".gitignore" "requirements.txt" "setup.py" "Dockerfile" "docker-compose.yml")

# Function to create directories
create_directories() {
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
  echo "Setting up local deployment for $REPO_NAME..."

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
    command: uvicorn src.main:app --host 0.0.0.0 --port 8000
EOL
  echo "Added docker-compose.yml."

  # Add a local environment file
  cat > local_env/.env <<EOL
# Local Environment Variables
API_KEY=your_api_key_here
DATABASE_URL=sqlite:///db.sqlite3
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

# Main script execution
echo "Provisioning backend and local deployment for repository: $REPO_NAME"
create_directories
create_files
setup_local_deployment
customize_repo

echo "Provisioning completed for $REPO_NAME."
