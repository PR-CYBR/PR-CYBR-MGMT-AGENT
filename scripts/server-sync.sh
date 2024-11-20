#!/bin/bash

# ------------------------------------- #
# Key Objectives for Server Sync Script #
# 
# 1. Update system
# 2. Perform Lynis system scan (and output to file)
# 3. Run the following workflow files:
#   - `server-sync.yml`
#   - `zerotier-config.yml`

# Update system
echo "Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

# Perform Lynis system scan
echo "Performing Lynis system scan..."
if ! command -v lynis &> /dev/null; then
  echo "Lynis is not installed. Installing Lynis..."
  sudo apt-get install -y lynis
fi

LYNIS_REPORT_DIR="/var/log/lynis"
LYNIS_REPORT_FILE="$LYNIS_REPORT_DIR/lynis-report-$(date +%Y%m%d%H%M%S).txt"
sudo mkdir -p $LYNIS_REPORT_DIR
sudo lynis audit system --quiet --logfile $LYNIS_REPORT_FILE
echo "Lynis scan complete. Report saved to $LYNIS_REPORT_FILE."

# Trigger GitHub Actions workflows
echo "Triggering GitHub Actions workflows..."

# Function to trigger a GitHub Actions workflow
trigger_workflow() {
  local workflow_name=$1
  local token=$2
  local repo=$3

  curl -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $token" \
    https://api.github.com/repos/$repo/actions/workflows/$workflow_name/dispatches \
    -d '{"ref":"main"}'
}

# Ensure GITHUB_TOKEN and REPO are set
if [ -z "$GITHUB_TOKEN" ] || [ -z "$REPO" ]; then
  echo "Error: GITHUB_TOKEN and REPO must be set as environment variables."
  exit 1
fi

# Trigger the workflows
trigger_workflow "server-sync.yml" $GITHUB_TOKEN $REPO
trigger_workflow "zerotier-config.yml" $GITHUB_TOKEN $REPO

echo "Server sync complete."