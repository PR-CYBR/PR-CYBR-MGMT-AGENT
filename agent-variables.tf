#############################################
# PR-CYBR Agent Variables (Agent-Level Only)
# This file declares variables for agent-level
# workspaces in Terraform Cloud.
# GLOBAL_* variables are managed at the 
# orchestration layer only.
#############################################

# --- Agent Tokens ---
variable "AGENT_ACTIONS" {
  type        = string
  sensitive   = true
  description = "Token for CI/CD pipelines (builds, tests, deploys)"
}

# --- Notion Integration (Agent-Specific) ---
variable "NOTION_TOKEN" {
  type        = string
  sensitive   = true
  description = "Notion API token for agent workspace"
}

variable "NOTION_PAGE_ID" {
  type        = string
  description = "Notion page ID for this specific agent"
}

variable "NOTION_DISCUSSIONS_ARC_DB_ID" {
  type        = string
  description = "Notion discussions archive database ID"
  default     = ""
}

variable "NOTION_ISSUES_BACKLOG_DB_ID" {
  type        = string
  description = "Notion issues backlog database ID"
  default     = ""
}

variable "NOTION_KNOWLEDGE_FILE_DB_ID" {
  type        = string
  description = "Notion knowledge/file database ID"
  default     = ""
}

variable "NOTION_PR_BACKLOG_DB_ID" {
  type        = string
  description = "Notion PR backlog database ID"
  default     = ""
}

variable "NOTION_PROJECT_BOARD_BACKLOG_DB_ID" {
  type        = string
  description = "Notion project board backlog database ID"
  default     = ""
}

variable "NOTION_TASK_BACKLOG_DB_ID" {
  type        = string
  description = "Notion task backlog database ID"
  default     = ""
}

# --- Terraform Cloud ---
variable "TFC_TOKEN" {
  type        = string
  sensitive   = true
  description = "Terraform Cloud API token"
}

#############################################
# NOTE: The following variables are managed
# at the orchestration layer and should NOT
# be defined in agent-level workspaces:
#
# - DOCKERHUB_TOKEN
# - DOCKERHUB_USERNAME
# - GLOBAL_DOMAIN
# - GLOBAL_ELASTIC_URI
# - GLOBAL_GRAFANA_URI
# - GLOBAL_KIBANA_URI
# - GLOBAL_PROMETHEUS_URI
# - GLOBAL_TAILSCALE_AUTHKEY
# - GLOBAL_TRAEFIK_ACME_EMAIL
# - GLOBAL_TRAEFIK_ENTRYPOINTS
# - GLOBAL_ZEROTIER_NETWORK_ID
# - AGENT_COLLAB
#############################################
