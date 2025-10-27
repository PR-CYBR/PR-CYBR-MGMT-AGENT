#############################################
# PR-CYBR Agent Variables (Generic Baseline)
# This file declares variables expected by
# Terraform Cloud across all PR-CYBR Agents.
# Real values are securely managed in TFC.
#############################################

# --- Docker / Registry ---
variable "DOCKERHUB_TOKEN" {
  type        = string
  sensitive   = true
  description = "Docker Hub access token"
}

variable "DOCKERHUB_USERNAME" {
  type        = string
  description = "Docker Hub username"
}

variable "PR_CYBR_DOCKER_PASS" {
  type        = string
  sensitive   = true
  description = "GitHub Actions secret for pushing Docker images"
}

variable "PR_CYBR_DOCKER_USER" {
  type        = string
  description = "Docker Hub account used for publishing images"
}

# --- Global Infrastructure URIs ---
variable "GLOBAL_DOMAIN" {
  type        = string
  description = "Root DNS domain for PR-CYBR services"
}

variable "GLOBAL_ELASTIC_URI" {
  type        = string
  description = "Elasticsearch endpoint"
}

variable "GLOBAL_GRAFANA_URI" {
  type        = string
  description = "Grafana endpoint"
}

variable "GLOBAL_KIBANA_URI" {
  type        = string
  description = "Kibana endpoint"
}

variable "GLOBAL_PROMETHEUS_URI" {
  type        = string
  description = "Prometheus endpoint"
}

# --- Networking / Security ---
variable "GLOBAL_TAILSCALE_AUTHKEY" {
  type        = string
  sensitive   = true
  description = "Auth key for Tailscale VPN/DNS"
}

variable "GLOBAL_TRAEFIK_ACME_EMAIL" {
  type        = string
  description = "Email used by Traefik for Let's Encrypt"
}

variable "GLOBAL_TRAEFIK_ENTRYPOINTS" {
  type        = string
  description = "Default entrypoints for Traefik"
}

variable "GLOBAL_ZEROTIER_NETWORK_ID" {
  type        = string
  sensitive   = true
  description = "ZeroTier overlay network ID"
}

# --- Agent Tokens ---
variable "AGENT_ACTIONS" {
  type        = string
  sensitive   = true
  description = "Token for CI/CD pipelines (builds, tests, deploys)"
}

variable "AGENT_COLLAB" {
  type        = string
  sensitive   = true
  description = "Token for governance, discussions, issues, project boards"
}

# --- GitHub / Terraform Cloud Auth ---
variable "GH_TOKEN" {
  type        = string
  sensitive   = true
  description = "Repository token for dispatching cross-agent workflows"
}

variable "GITHUB_TOKEN" {
  type        = string
  sensitive   = true
  description = "Automation token for repository operations"
}

variable "TFC_TOKEN" {
  type        = string
  sensitive   = true
  description = "Terraform Cloud API token used by the tfc-sync workflow"
}

# --- Notion Integrations ---
variable "NOTION_DISCUSSIONS_ARC_DB_ID" {
  type        = string
  description = "Database identifier for the discussions archive"
}

variable "NOTION_ISSUES_BACKLOG_DB_ID" {
  type        = string
  description = "Database identifier for the issues backlog"
}

variable "NOTION_KNOWLEDGE_FILE_DB_ID" {
  type        = string
  description = "Database identifier for the knowledge file catalog"
}

variable "NOTION_PAGE_ID" {
  type        = string
  description = "Workspace page that anchors the management portal"
}

variable "NOTION_PR_BACKLOG_DB_ID" {
  type        = string
  description = "Database identifier for the pull request backlog"
}

variable "NOTION_PROJECT_BOARD_BACKLOG_DB_ID" {
  type        = string
  description = "Database identifier for the project board backlog"
}

variable "NOTION_TASK_BACKLOG_DB_ID" {
  type        = string
  description = "Database identifier for the task backlog"
}

variable "NOTION_TOKEN" {
  type        = string
  sensitive   = true
  description = "Integration token used to access Notion workspaces"
}

# --- Assistant Runtime ---
variable "ASSISTANT_ID" {
  type        = string
  description = "Default assistant identifier used by management automations"
}
